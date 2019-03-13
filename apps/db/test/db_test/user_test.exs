defmodule DbTest.UserTest do
  use DbTest.RepoCase, async: true

  alias Db.User

  @test_email "test@test.com"
  @another_email "test2@test.com"
  @test_passwd "password"

  @tag capture_log: true
  test "add user | findAll" do
    assert [] == User.findAll
    
    User.add @test_email, @test_passwd
    users = User.findAll
    assert 1 == length users
    assert [%User{}] = users 
  end

  @tag capture_log: true
  test "find by email" do
    assert [] == User.findAll
    
    User.add @test_email, @test_passwd
    user = User.findOne @test_email, %{}
    assert %User{} = user

    user = User.findOne @another_email, %{}
    assert user == nil
  end
end