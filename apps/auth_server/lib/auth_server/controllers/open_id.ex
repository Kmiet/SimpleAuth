defmodule AuthServer.Controllers.OpenIDController do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "OpenID")
  end

  get "/signin" do
    send_resp(conn, 200, "OpenID SignIn")
  end 

end