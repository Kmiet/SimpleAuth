defmodule AuthServerTest.ControllerTest.OpenIDTest do
  use AuthServerTest.RouterCase, async: true

  test "reaches endpoint" do
    conn = 
      conn(:get, "/openid") 
      |> Router.call(@router_opts)
      
    assert conn.status == 200
    assert conn.resp_body == "OpenID"
  end

  test "" do
    conn =
      conn(:get, "/openid/signin")
      |> Router.call(@router_opts)

    assert conn.status == 200
  end
end