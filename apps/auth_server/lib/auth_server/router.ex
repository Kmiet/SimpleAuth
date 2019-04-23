defmodule AuthServer.Router do
  use Plug.Router

  alias AuthServer.Controllers.OAuthController
  alias AuthServer.Controllers.SignUpController

  plug Plug.Static, at: "/", from: "../layout/build/login_form"

  plug :match
  plug :dispatch

  forward "/oauth", to: OAuthController 

  forward "/signup", to: SignUpController

  get "/" do
    send_resp(conn, 200, "AuthServer")
  end

  get "/login" do
    send_file(conn, 200, "../layout/build/login_form/index.html")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end