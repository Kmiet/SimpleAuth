defmodule AuthServerTest.ControllerTest.OAuthTest.AuthorizeTest do
  use AuthServerTest.RouterCase, async: true

  test "No params" do
    conn = 
      conn(:get, "/oauth/authorize") 
      |> Router.call(@router_opts)
      
    assert conn.status == 200
    assert conn.resp_body == "OAuth authorize"
  end
end