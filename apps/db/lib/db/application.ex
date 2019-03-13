defmodule Db.Application do
  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      {Db.Repo, []},
    ]

    opts = [strategy: :one_for_one, name: Db.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
