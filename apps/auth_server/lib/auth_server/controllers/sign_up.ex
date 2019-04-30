defmodule AuthServer.Controllers.SignUpController do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_file(conn, 200, "../layout/build/login_form/index.html")
  end 

end