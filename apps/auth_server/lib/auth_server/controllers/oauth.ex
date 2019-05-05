defmodule AuthServer.Controllers.OAuthController do
  use Plug.Router

  alias Db.Repo
  alias Db.Models.{Client, ClientUser, User}
  alias Cache
  alias Token

  @csrf_cookie_key "ftk"

  plug :match
  plug :dispatch

  get "/authorize" do
    Plug.Conn.fetch_query_params(conn)
    |> put_resp_header("content-type", "application/json")
    |> handle_authorize
  end

  # User Consent
  post "/authorize" do
    conn = Plug.Conn.fetch_query_params(conn)
    |> put_resp_header("content-type", "application/json")
    with %{"consent" => consent_id} <- conn.query_params,
      consent_data when not is_nil(consent_data) <- Cache.ConsentSessions.get(consent_id),
      {client_id, user_id, grant_type, redirect_uri, state} <- consent_data,
      consent_token when not is_nil(consent_token) <- fetch_cookie(conn, consent_id),
      {:ok, %{"scope" => client_scopes, "consent" => consent}} = Token.validate_and_verify(consent_token, %{
        "client_id" => client_id,
        "user_id" => user_id
      }),
      true <- consent_matches?(client_scopes, consent, new)
    do
      Cache.ConsentSessions.delete(consent_id)
      case grant_type do
        "code" ->
        "id_token" ->
      end
      conn
      |> put_resp_header("location", redirect_uri)
      |> send_resp(302)
    else
      _ -> send_resp(conn, 401, "")
    end 
  end

  defp handle_authorize(%{:query_params => %{"redirect_uri" => "https://accounts.simpleauth.org/"}} = conn) do
    with {:ok, {email, password, csrf_token}} <- fetch_credentials(conn),
      form_token when not is_nil(form_token) <- fetch_cookie(conn, @csrf_cookie_key),
      true <- form_token == csrf_token,
      user_data when not is_nil(user_data) <- Repo.one(
        from u in User, 
          where: u.email == ^email,
          select: {u.id, u.password}
      ),
      true <- user_data.password == password
    do
      conn
      |> put_resp_cookie("id", Token.create(%{
          "aud" => "https://simpleauth.org/",
          "sub" => user_data.id
        }, 43200), [domain: ".simpleauth.org", http_only: true, max_age: 43200, path: "/", secure: true])
      |> put_resp_header("location", "https://accounts.simpleauth.org/")
      |> send_resp(302, "")
    else
      _ -> send_resp conn, 401, ""
    end
  end

  defp handle_authorize(%{:query_params => %{"client_id" => client_id, "grant_type" => grant_type, "redirect_uri" => redirect_uri, "state" => state}} = conn) do
    with {:ok, {email, password, csrf_token}} <- fetch_credentials(conn),
      true <- Enum.member?(["code", "id_token"], grant_type), 
      client_data when not is_nil(client_data) <- Repo.one(
        from c in Client, 
          left_join: cu in ClientUser, on: cu.client_id == c.id,
          right_join: u in User, on: cu.user_id == u.id 
          where: c.client_id == ^client_id and u.email == ^email
      ),
      true <- Enum.member?(client_data.login_redirects, redirect_uri),
      :ok <- check_grant_type(client_data.flow),
      form_token when not is_nil(form_token) <- fetch_cookie(conn, @csrf_cookie_key),
      true <- form_token == csrf_token,
      true <- password == client_data.password
    do
      if is_nil(client_data.consent) or not consent_matches?(client_data.user_scopes, client_data.consent) do
        consent_id = :crypto.strong_rand_bytes(24) |> Base.url_encode64
        Cache.ConsentSessions.insert(consent_id, {client_id, clien_data.user_id, grant_type, redirect_uri, state})
        conn
        |> put_resp_cookie(consent_id, Token.create(%{
          "client_id" => client_id,
          "user_id" => client_data.user_id,
          "scopes" => client_data.user_scopes,
          "consent" => client_data.consent 
        }, 180), [http_only: true, max_age: 180, path: "/oauth/authorize", secure: true])
        |> send_resp(200, "Ask user for permission for the client to access their data")
      else
        case grant_type do
          "code" -> ""
          "id_token" -> ""
        end
        conn
        |> put_resp_cookie("id", Token.create(%{
          "aud" => client_id,
          "sub" => client_data.user_id
        }, 43200), [domain: ".simpleauth.org", http_only: true, max_age: 43200, path: "/", secure: true])
        |> put_resp_header("location", redirect_uri)
        |> send_resp(302, "")
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

  # Helpers

  defp fetch_credentials(%{:req_headers => headers} = conn) do
    headers
    |> Enum.find({"Authorization", _})
    |> elem(1)
    |> String.split(" ")
    |> tl #tail
    |> fn tail -> 
      if length(tail) == 3 do
        {:ok, List.to_tuple(tail)}
      else
        {:error, tail}
      end
  end

  defp fetch_cookie(%{:req_cookies => cookies} = conn, key) do
    cookies
    |> Map.get(key)
  end

  defp consent_matches?(client_scopes, current, new \\ []) do
    merged = current ++ new
    client_scopes
    |> Enum.all?(fn s -> Enum.member?(merged, s) end)
  end

end