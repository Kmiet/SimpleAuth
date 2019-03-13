defmodule DbTest.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Db.Repo

      import Ecto
      import Ecto.Query
      import DbTest.RepoCase
      
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Db.Repo)
    
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Db.Repo, {:shared, self()})
    end
    
    :ok
  end
end
