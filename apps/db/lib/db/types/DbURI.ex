defmodule Db.Types.DbURI do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(uri) when is_binary(uri), do: cast(URI.parse(uri))

  def cast(%URI{host: host} = uri) when is_nil(host), do: :error

  def cast(%URI{port: port} = uri) when port != 80 and port != 443, do: {:ok, %{uri | scheme: "https"}}

  def cast(%URI{} = uri), do: {:ok, %{uri | scheme: "https", port: nil}}

  def cast(_), do: :error

  def load(data), do: {:ok, data}

  def dump(%URI{} = uri), do: {:ok, URI.to_string(uri)}  
  
  def dump(_), do: :error

end