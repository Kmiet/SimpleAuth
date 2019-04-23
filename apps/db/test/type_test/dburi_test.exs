defmodule DbTest.TypeTest.DbURITest do
  use ExUnit.Case, async: true

  alias Db.Types.DbURI

  test "DbURI - cast func" do
    {:ok, res} = DbURI.cast("http://example.com/")
    assert %URI{} = res
    assert Map.get(res, :host) == "example.com"
    assert Map.get(res, :scheme) == "https"
    assert Map.get(res, :port) == nil

    {:ok, res} = DbURI.cast("//foo.bar/")
    assert %URI{} = res
    assert Map.get(res, :host) == "foo.bar"
    assert Map.get(res, :scheme) == "https"
    assert Map.get(res, :port) == nil

    {:ok, res} = DbURI.cast("//foo.bar:4096/")
    assert %URI{} = res
    assert Map.get(res, :host) == "foo.bar"
    assert Map.get(res, :scheme) == "https"
    assert Map.get(res, :port) == 4096

    assert DbURI.cast("/hello") == :error
    assert DbURI.cast("string") == :error
    assert DbURI.cast(4) == :error
  end

  test "DbURI - dump func" do
    assert DbURI.dump(%URI{}) == {:ok, ""}
    {:ok, uri} = DbURI.cast("http://example.com/")
    assert DbURI.dump(uri) == {:ok, "https://example.com/"}
    {:ok, uri} = DbURI.cast("http://example.com:4096/")
    assert DbURI.dump(uri) == {:ok, "https://example.com:4096/"}
    
    assert DbURI.dump("string") == :error
    assert DbURI.dump(4) == :error
  end

  test "DbURI - load func" do
    assert DbURI.load("https://example.com/") == {:ok, "https://example.com/"}
  end
  
end