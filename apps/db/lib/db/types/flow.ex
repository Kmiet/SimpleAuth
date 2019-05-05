defmodule Db.Types.Flow do
  @behaviour Ecto.Type
  def type, do: :integer

  def cast(flow) when is_binary(flow) do
    case flow do
      "authorization_code" -> {:ok, 0}
      "implicit" -> {:ok, 1}
      "hybrid" -> {:ok, 2}
      _ -> :error
    end
  end

  def cast(_), do: :error

  def load(data) when is_integer(data) do
    case data do
      0 -> {:ok, "authorization_code"}
      1 -> {:ok, "implicit"}
      2 -> {:ok, "hybrid"}
    end
  end

  def dump(flow) when is_integer(flow) and flow >= 0 and flow <= 2, do: {:ok, flow}
  
  def dump(_), do: :error

end