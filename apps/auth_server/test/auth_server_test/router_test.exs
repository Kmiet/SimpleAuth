defmodule AuthServerTest.RouterTest do
  use AuthServerTest.RouterCase, async: true

  test "reaches endpoint" do
    conn = 
      conn(:get, "/") 
      |> Router.call(@router_opts)
      
    assert conn.status == 200
    assert conn.resp_body == "AuthServer"
  end

  test "" do
    conn =
      conn(:get, "/notFound")
      |> Router.call(@router_opts)

    assert conn.status == 404
  end
end
