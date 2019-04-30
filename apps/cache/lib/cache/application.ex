defmodule Cache.Application do
  use Application
  
  def start(_type, _args) do
    children = [
      {Cache.Keys, []}
    ]

    options = [strategy: :one_for_all, name: Cache.Supervisor]
    Supervisor.start_link(children, options)
  end
end