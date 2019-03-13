defmodule AuthServer do
  use Application
  alias AuthServer.Router

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: Application.get_env(:auth_server, :port)]}
    ]

    options = [strategy: :one_for_one, name: AuthServer.Supervisor]
    Supervisor.start_link(children, options)
  end
end
