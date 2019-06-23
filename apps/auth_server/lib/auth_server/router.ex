defmodule AuthServer.Router do
  use Plug.Router

  alias Utils.Plugs.{QueryParamsPlug, SessionPlug}
  alias AuthServer.Controllers.{ForgotPasswordController, LogInController, OAuthController, SignUpController}

  plug Plug.Static, at: "/", from: "../layout/build/login_form"

  plug QueryParamsPlug
  # SessionPlug fetches all cookies into conn stuct
  plug SessionPlug

  plug :match
  plug :dispatch

  forward "/oauth", to: OAuthController 

  forward "/signup", to: SignUpController

  forward "/login", to: LogInController

  forward "/forgot-password", to: ForgotPasswordController

  get "/" do
    with true <- conn.assigns[:logged_in] do
      conn
      |> put_resp_header("content-type", "text/html")
      |> send_resp(200, "Hi, you are logged in!")
    else
      _ ->
        conn
        |> put_resp_header("location", "http://localhost:4000/login")
        |> send_resp(302, "")
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end

end