defmodule DbTest.TypeTest.UserScopeTest do
  use ExUnit.Case, async: true

  alias Db.Types.UserScope

  test "UserScope - cast func" do
    assert UserScope.cast("openid") == {:ok, 0}
    assert UserScope.cast("profile") == {:ok, 1}
    assert UserScope.cast("email") == {:ok, 2}
    assert UserScope.cast("address") == {:ok, 3}
    assert UserScope.cast("phone") == {:ok, 4}

    assert UserScope.cast("string") == :error
    assert UserScope.cast(4) == :error
  end

  test "UserScope - dump func" do
    assert UserScope.dump(0) == {:ok, 0}
    assert UserScope.dump(1) == {:ok, 1}
    assert UserScope.dump(2) == {:ok, 2}
    assert UserScope.dump(3) == {:ok, 3}
    assert UserScope.dump(4) == {:ok, 4}

    assert UserScope.dump("string") == :error
    assert UserScope.dump(-1) == :error
    assert UserScope.dump(5) == :error
  end

  test "UserScope - load func" do
    assert UserScope.load(0) == {:ok, "openid"}
    assert UserScope.load(1) == {:ok, "profile"}
    assert UserScope.load(2) == {:ok, "email"}
    assert UserScope.load(3) == {:ok, "address"}
    assert UserScope.load(4) == {:ok, "phone"}
  end
  
end