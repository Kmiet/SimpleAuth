defmodule AuthServerTest.RouterCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias AuthServer.Router

      use Plug.Test

      @router_opts Router.init([])
       
    end
  end
end