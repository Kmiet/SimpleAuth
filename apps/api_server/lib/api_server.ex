defmodule ApiServer do
  use Application
  alias ApiServer.Router

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: Application.get_env(:api_server, :port)]}
    ]

    options = [strategy: :one_for_one, name: ApiServer.Supervisor]
    Supervisor.start_link(children, options)
  end
end
