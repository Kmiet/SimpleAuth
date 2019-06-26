defmodule Cache.Application do
  use Application
  
  def start(_type, _args) do
    children = [
      {Cache.AuthCodes, []},
      {Cache.ConsentSessions, []},
      {Cache.EmailConfirmations, []},
      {Cache.Keys, []},
      {Cache.Sessions, []},
      {Cache.PasswordResets, []},
    ]

    options = [strategy: :one_for_all, name: Cache.Supervisor]
    Supervisor.start_link(children, options)
  end
end