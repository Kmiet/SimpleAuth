defmodule AuthServer.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "AuthServer")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end