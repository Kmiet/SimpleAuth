defmodule AuthServerTest.LoginTest do
  use AuthServerTest.RouterCase, async: true

  test "Not authenticated - /login" do
    conn =
      conn(:get, "/login")
      |> Router.call(@router_opts)

    assert conn.status == 200
  end

  test "Authenticated - /login" do
    conn =
      conn(:get, "/login")
      |> Router.call(@router_opts)

    assert conn.status == 302
  end
end
