defmodule DbTest.UserTest do
  use DbTest.RepoCase, async: true

  alias Db.Models.User

  @test_email "test@test.com"
  @another_email "test2@test.com"
  @test_passwd "password"

  @tag capture_log: true
  test "add user | findAll" do
  end

  @tag capture_log: true
  test "find by email" do
  end
end