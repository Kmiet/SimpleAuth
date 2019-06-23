defmodule AuthServer.Controllers.ForgotPasswordController do
  use Plug.Router

  import Ecto.Query

  alias Db.Repo
  alias Db.Models.User
  alias Cache.PasswordResets
  alias Mailer.ForgotPasswordEmail

  plug Plug.Static, at: "/", from: "../layout/build/login_form"

  plug :match
  plug :dispatch

  # Password Reset form

  get "/reset" do
    conn = Plug.Conn.fetch_query_params(conn)
    with %{:query_params => %{"id" => reset_id}} = conn,
      {email, _req_url} when not is_nil(email) <- PasswordResets.get(reset_id)
    do
      form_token = :crypto.strong_rand_bytes(24) |> Base.url_encode64
      conn
      |> Utils.Cookies.put_csrf_cookie(form_token)
      |> put_resp_header("content-type", "text/html")
      |> send_resp(200, EEx.eval_file(
        "priv/assets/other/password_reset.html.eex",
        [csrf_token: form_token]
      ))
    else
      %{} -> send_file(conn, 400, "priv/assets/bad_request.html")
      _ -> send_file(conn, 404, "priv/assets/not_found.html")  
    end
  end

  # New password data {change read_body to work with URL_ENCODED}

  post "/reset" do
    {:ok, body, conn} = 
      conn
      |> Plug.Conn.fetch_query_params
      |> Plug.Conn.fetch_cookies
      |> Plug.Conn.read_body
    with %{:query_params => %{"id" => reset_id}} = conn,
      {email, req_url} when not is_nil(email) <- PasswordResets.get(reset_id),
      form_token when not is_nil(form_token) <- Utils.Cookies.fetch_csrf_cookie(conn),
      {:ok, %{ "csrf_token" => csrf_token, "password" => password }} = Jason.decode(body),
      true <- form_token == csrf_token
    do
      PasswordResets.delete(reset_id)
      Repo.update_all(
        (from u in User,
          where: u.email == ^email), 
        set: [password: password])
      conn
      |> put_resp_header("location", req_url)
      |> send_resp(302, "")
    else
      %{} -> send_file(conn, 400, "priv/assets/bad_request.html")
      _ -> send_file(conn, 404, "priv/assets/not_found.html")  
    end
  end

  get "/" do
    form_token = :crypto.strong_rand_bytes(24) |> Base.url_encode64
    conn
    |> Utils.Cookies.put_csrf_cookie(form_token)
    |> put_resp_header("content-type", "text/html")
    |> send_resp(200, EEx.eval_file(
        "priv/assets/login/index.html.eex",
        [csrf_token: form_token]
      ))
  end

  post "/" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)
    with {:ok, %{ "csrf_token" => csrf_token, "email" => email }} = Jason.decode(body),
      form_token when not is_nil(form_token) <- Utils.Cookies.fetch_csrf_cookie(conn),
      true <- form_token == csrf_token
    do
      reset_id = :crypto.strong_rand_bytes(64) |> Base.url_encode64
      PasswordResets.insert(reset_id, {email, Plug.Conn.request_url(conn)})
      Task.start(fn ->
        ForgotPasswordEmail.prepare(email, "http://localhost:4000/forgot-password/reset?id=" <> reset_id)
        |> Mailer.deliver
      end)
      conn
      |> send_resp(201, "")
    else
      %{} -> send_file(conn, 400, "priv/assets/bad_request.html")
      _ -> send_file(conn, 403, "priv/assets/forbidden.html") 
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end
end