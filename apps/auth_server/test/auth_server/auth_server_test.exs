defmodule AuthServer.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias AuthServer.Router

  @router_opts Router.init([])

  test "reaches endpoint" do
    conn = 
      conn(:get, "/") 
      |> Router.call(@router_opts)
      
    assert conn.status == 200
    assert conn.resp_body == "AuthServer"
  end
end
