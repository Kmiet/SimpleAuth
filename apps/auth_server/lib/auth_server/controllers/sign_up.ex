defmodule AuthServer.Controllers.SignUpController do
  use Plug.Router

  import Ecto.Query

  alias Db.Repo
  alias Db.Models.User
  alias Cache.EmailConfirmations
  alias Mailer.SignUpEmail

  @csrf_cookie_key "ftk"

  plug :match
  plug :dispatch

  get "/emc" do
    IO.inspect EmailConfirmations.all
    send_resp conn, 200, "OK"
  end

  get "/confirm" do
    conn = Plug.Conn.fetch_query_params(conn)
    with %{:query_params => %{"id" => confirmation_id}} = conn,
      uid when not is_nil(uid) <- EmailConfirmations.get(confirmation_id)
    do
      EmailConfirmations.delete(confirmation_id)
      Repo.update_all(
        (from u in User,
          where: u.id == ^uid), 
        set: [verified_email: true])
      send_file(conn, 200, "priv/assets/other/email_confirmed.html")
    else
      %{} -> send_file(conn, 400, "priv/assets/bad_request.html")
      _ -> send_file(conn, 404, "priv/assets/not_found.html")  
    end
  end

  get "/list" do
    data = Repo.all(from u in User)
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, Jason.encode!(data))
  end

  get "/" do
    form_token = :crypto.strong_rand_bytes(24) |> Base.url_encode64
    conn
    |> put_resp_cookie(@csrf_cookie_key, form_token, [http_only: true]) #,secure: true])
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, EEx.eval_file(
        "priv/assets/login/index.html.eex",
        [csrf_token: form_token]
      ))
  end

  post "/" do
    conn = Plug.Conn.fetch_cookies(conn)
    {:ok, body, conn} = 
      conn 
      |> Plug.Conn.fetch_cookies
      |> Plug.Conn.read_body
    with {:ok, %{ "csrf_token" => csrf_token, "email" => email, "password" => password }} = Jason.decode(body),
      form_token when not is_nil(form_token) <- fetch_cookie(conn, @csrf_cookie_key),
      true <- form_token == csrf_token
    do
      with uid <- Repo.insert!(%User{
          email: email,
          password: password
        }).id
      do
        confirmation_id = :crypto.strong_rand_bytes(24) |> Base.url_encode64
        EmailConfirmations.insert(confirmation_id, uid)
        # SignUpEmail.prepare(email, "http://localhost:4000/signup/confirm?id=" <> confirmation_id)
        # |> Mailer.deliver
        conn
        |> delete_resp_cookie(@csrf_cookie_key, [http_only: true]) #, secure: true])
        |> send_resp(201, "")
      else
        {:error, changeset} -> send_resp(conn, 500, changeset)
      end
    else
      _ -> send_resp(conn, 403, "")
    end
  end

  # Helpers

  defp fetch_cookie(%{:req_cookies => cookies}, key) do
    cookies
    |> Map.get(key)
  end
end