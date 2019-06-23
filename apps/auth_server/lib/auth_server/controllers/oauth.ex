defmodule AuthServer.Controllers.OAuthController do
  use Plug.Router

  import Ecto.Query

  alias Db.Repo
  alias Db.Models.{Client, ClientUser, ClientSession, User, Session}
  alias Cache.{AuthCodes, ConsentSessions, Sessions}
  alias Token

  plug :match
  plug :dispatch

  get "/authorize" do
    with false <- conn.assigns[:logged_in] do
      conn
      |> put_resp_header("content-type", "application/json")
      |> handle_authorize
    else
      _ -> handle_logged_in(conn)
    end
  end

  # User Consent
  post "/authorize" do
    conn = put_resp_header(conn, "content-type", "application/json")
    with true <- conn.assigns[:logged_in],
      {:ok, body, conn} <- Plug.Conn.read_body(conn),
      {:ok, %{ "csrf_token" => csrf_token, "consent" => consent }} <- Jason.decode(body),

      %{"consent" => consent_session_id} <- conn.query_params,
      consent_data when not is_nil(consent_data) <- ConsentSessions.get(consent_id),
      {client_id, client_secret, user_id, grant_type, redirect_uri, state} <- consent_data,

      consent_token when not is_nil(consent_token) <- Utils.Cookies.fetch_cookie(conn, consent_id),
      {:ok, %{"scopes" => client_scopes}} = Token.validate_and_verify(consent_token, %{
        "client_id" => client_id,
        "user_id" => user_id
      }),
      true <- consent_matches?(client_scopes, consent)
    do
      ConsentSessions.delete(consent_id)

      res_uri = build_response_uri(redirect_uri, grant_type, client_id, client_secret, user_id, state)
      conn
      |> put_resp_header("location", res_uri)
      |> send_resp(302, "")
    else
      nil -> send_resp(conn, 404, "")
      _ -> send_resp(conn, 401, "")
    end 
  end

  defp handle_authorize(%{:query_params => %{"redirect_uri" => "https%3A%2F%2Faccounts.simpleauth.org%2F"}} = conn) do
    with {:ok, {email, password, csrf_token}} <- fetch_credentials(conn),
      form_token when not is_nil(form_token) <- Utils.Cookies.fetch_csrf_cookie(conn),
      true <- form_token == csrf_token,

      user_data when not is_nil(user_data) <- Repo.one(
        from u in User, 
          where: u.email == ^email
      ),
      true <- user_data.password == password
    do
      with sid <- Repo.insert!(%Session{}).id,
        _ <- Sessions.insert(sid, [])
      do
        conn
        |> put_resp_header("content-type", "text/html")
        |> put_resp_cookie("id", Token.create(%{
            "aud" => "https://simpleauth.org",
            "sub" => user_data.id,
            "sid" => sid
          }, 43200), [http_only: true, max_age: 43200, path: "/"]) # [domain: ".simpleauth.org", http_only: true, max_age: 43200, path: "/", secure: true])
        |> put_resp_header("location", "http://localhost:4000/") # "https://accounts.simpleauth.org/")
        |> send_resp(302, "")
      else
        _ -> send_resp(conn, 500, "")   
      end
    else
      {:error, _tail} ->
        send_resp(conn, 400, "")
      _ -> send_resp(conn, 401, "")
    end
  end

  defp handle_authorize(%{:query_params => %{"client_id" => client_id, "grant_type" => grant_type, "redirect_uri" => r_uri, "state" => state}} = conn) do
    with {:ok, {email, password, csrf_token}} <- fetch_credentials(conn),
      redirect_uri <- URI.decode(r_uri),
      true <- Enum.member?(["code", "id_token"], grant_type),
      form_token when not is_nil(form_token) <- Utils.Cookies.fetch_csrf_cookie(conn),
      true <- form_token == csrf_token,

      user_data when not is_nil(user_data) <- Repo.one(
        from u in User,
          where: u.email == ^email,
          select: %{id: u.id, password: u.password}
      ),
      true <- password == user_data.password,
      {:ok, uid} <- Ecto.UUID.dump(user_data.id),

      client_data when not is_nil(client_data) <- Repo.one(
        from c in Client, 
          left_join: cu in ClientUser, on: cu.client_id == c.id, 
          where: c.id == ^client_id and coalesce(cu.user_id, ^uid) == ^uid,
          select: %{
            secret: c.secret,
            consent: cu.consent, 
            login_redirects: 
            c.login_redirects, 
            user_scopes: c.user_scopes
          }
      ),
      true <- Enum.member?(client_data.login_redirects, redirect_uri)
      # :ok <- check_grant_type(client_data.flow, grant_type)
    do
      conn = put_resp_cookie(conn, "id", Token.create(%{
        "aud" => "https://simpleauth.org/",
        "sub" => user_data.id,
        "sid" => sid
      }, 43200), [domain: ".simpleauth.org", http_only: true, max_age: 43200, path: "/", secure: true])

      if is_nil(client_data.consent) or not consent_matches?(client_data.user_scopes, client_data.consent) do
        consent_id = :crypto.strong_rand_bytes(24) |> Base.url_encode64
        ConsentSessions.insert(consent_id, {client_id, client_data.secret, user_data.id, grant_type, redirect_uri, state})

        conn
        |> put_resp_cookie(consent_id, Token.create(%{
            "aud" => "CONSENT_" <> user_data.id,
            "client_id" => client_id,
            "user_id" => user_data.id,
            "scopes" => client_data.user_scopes
          }, 300), [max_age: 300]) #[http_only: true, max_age: 180, path: "/oauth/authorize", secure: true])
        |> send_resp(200, "Ask user for permission for the client to access their data")
      else
        with sid <- Repo.insert!(%Session{}).id,
          _ <- Sessions.insert(sid, [client_id])
        do
          Repo.insert!(%ClientSession{begin_times: [dynamic(fragment("(now() at time zone 'utc')"))], end_times: [], session_id: sid, client_id: client_id})
          res_uri = build_response_uri(redirect_uri, grant_type, client_id, client_data.secret, client_data.user_id, state)

          conn
          |> put_resp_header("location", res_uri)
          |> send_resp(302, "")
        else
          _ -> send_resp(conn, 500, "")   
        end
      end
    else
      _ -> send_resp(conn, 401, "")
    end
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _, "grant_type" => _, "redirect_uri" => _}} = conn) do
    send_resp conn, 400, "State param is missing"
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _, "grant_type" => _}} = conn) do
    send_resp conn, 400, "RedirectURI param is missing"
  end

  defp handle_authorize(%{:query_params => %{"client_id" => _}} = conn) do
    send_resp conn, 400, "GrantType param is missing"
  end

  defp handle_authorize(conn) do
    send_resp conn, 400, "ClientID param is missing"
  end

  # Logged In

  defp handle_logged_in(%{:query_params => %{"redirect_uri" => "https://accounts.simpleauth.org/"}} = conn) do
    conn
    |> put_resp_header("location", "http://localhost:4000/")
    |> send_resp(302, "")
  end

  defp handle_logged_in(%{:query_params => %{"client_id" => client_id, "grant_type" => grant_type, "redirect_uri" => redirect_uri, "state" => state}} = conn) do
    with session_id when not is_nil(session_id) <- conn.assigns[:session_id],
      user_id when not is_nil(user_id) <- conn.assigns[:user_id],
      session_data when not is_nil(session_data) <- Sessions.get(session_id),
      {session_clients, expiration_time} = session_data,

      client_session_data when not is_nil(client_session_data) <- Repo.one(
        from c in Client, 
          left_join: cs in ClientSession, on: cs.client_id == c.id,
          where: c.id == ^client_id and cs.session_id == ^session_id
      ),
      # :ok <- check_grant_type(client_session_data.flow, grant_type),

      true <- Enum.member?(client_session_data.login_redirects, redirect_uri)
    do
      if is_nil(client_session_data.is_active) do
        Sessions.insert(session_id, {user_id, session_clients ++ [client_id]}, expiration_time)
        Repo.insert!(%ClientSession{begin_times: [dynamic(fragment("(now() at time zone 'utc')"))], end_times: [], session_id: session_id, client_id: client_id})
      else 
        if not client_session_data.is_active do
          Sessions.insert(session_id, {user_id, session_clients ++ [client_id]}, expiration_time)
          (from cs in ClientSession,
              where: cs.client_id == ^client_id and cs.session_id == ^session_id,
              update: [
                push: [ begin_times: [fragment("(now() at time zone 'utc')")] ], 
                set: [ is_active: true ]
              ])
          |> Repo.update_all([])
        end
      end

      res_uri = build_response_uri(redirect_uri, grant_type, client_id, client_session_data.secret, user_id, state)
      conn
      |> put_resp_header("location", res_uri)
      |> send_resp(302, "")
    else
      _ -> send_resp(conn, 500, "")
    end
  end

  defp handle_logged_in(conn) do
    send_resp conn, 400, "Bad request"
  end

  match _ do
    send_resp(conn, 404, "")
  end

  # Helpers

  defp fetch_credentials(%{:req_headers => headers}) do
    headers
    # {header, value}
    |> Enum.find(fn {h, _v} -> h == "authorization" end)
    |> elem(1)
    |> String.split(" ")
    |> (fn creds -> if length(creds) == 3, do: {:ok, List.to_tuple(creds)}, else: {:error, creds} end).()
  end

  defp consent_matches?(client_scopes, current, new \\ []) do
    merged = current ++ new
    client_scopes
    |> Enum.all?(fn s -> Enum.member?(merged, s) end)
  end

  defp build_response_uri(redirect_uri, grant_type, client_id, client_secret, user_id, state) do
    case grant_type do
      "code" ->
        code = :crypto.strong_rand_bytes(24) |> Base.url_encode64
        AuthCodes.insert(code, {client_id, client_secret, user_id})
        Enum.join([redirect_uri, "?", "code=", code, "&state=", state])
      "id_token" ->
        Enum. join([redirect_uri, "#", "id_token=",
          Token.create(%{
            "aud" => client_id,
            "sub" => user_id
          }),
          "&state=", state])
    end
  end
end