defmodule AuthServer.Router do
  use Plug.Router

  alias AuthServer.Controllers.OpenIDController
  alias AuthServer.Controllers.SignUpController

  plug :match
  plug :dispatch

  forward "/openid", to: OpenIDController 

  forward "/signup", to: SignUpController

  get "/" do
    send_resp(conn, 200, "AuthServer")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end