defmodule DbTest.TypeTest.GenderTest do
  use ExUnit.Case, async: true

  alias Db.Types.Gender

  test "Gender - cast func" do
    assert Gender.cast("male") == {:ok, true}
    assert Gender.cast("female") == {:ok, false}

    assert Gender.cast("string") == :error
    assert Gender.cast(4) == :error
  end

  test "Gender - dump func" do
    assert Gender.dump(true) == {:ok, true}
    assert Gender.dump(false) == {:ok, false}
    
    assert Gender.dump("string") == :error
    assert Gender.dump(4) == :error
  end

  test "Gender - load func" do
    assert Gender.load(true) == {:ok, "male"}
    assert Gender.load(false) == {:ok, "female"}
  end
  
end