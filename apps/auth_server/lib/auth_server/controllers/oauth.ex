defmodule AuthServer.Controllers.OAuthController do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "OAuth")
  end

  get "/authorize" do
    send_resp(conn, 200, "OAuth authorize")
  end 

end