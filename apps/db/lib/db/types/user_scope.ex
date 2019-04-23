defmodule Db.Types.UserScope do
  @behaviour Ecto.Type
  def type, do: :integer

  def cast(scope) when is_binary(scope) do
    case scope do
      "openid" -> {:ok, 0}
      "profile" -> {:ok, 1}
      "email" -> {:ok, 2}
      "address" -> {:ok, 3}
      "phone" -> {:ok, 4}
      _ -> :error
    end
  end

  def cast(_), do: :error

  def load(data) when is_integer(data) do
    case data do
      0 -> {:ok, "openid"}
      1 -> {:ok, "profile"}
      2 -> {:ok, "email"}
      3 -> {:ok, "address"}
      4 -> {:ok, "phone"}
    end
  end

  def dump(scope) when is_integer(scope) and scope >= 0 and scope <= 4, do: {:ok, scope}
  
  def dump(_), do: :error

end