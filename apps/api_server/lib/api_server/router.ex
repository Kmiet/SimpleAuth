defmodule ApiServer.Router do
  use Plug.Router

  alias Utils.Plugs.{QueryParamsPlug, SessionPlug}
  alias ApiServer.{ClientsRouter}

  plug QueryParamsPlug
  # SessionPlug fetches all cookies into conn stuct
  plug SessionPlug

  plug :match
  plug :dispatch

  forward "/clients", to: ClientsRouter

  get "/" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, "Service info")
  end

  match _ do
    send_resp(conn, 404, "")
  end

end