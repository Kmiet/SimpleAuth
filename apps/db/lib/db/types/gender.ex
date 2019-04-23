defmodule Db.Types.Gender do
  @behaviour Ecto.Type
  def type, do: :boolean

  def cast(gender) when is_binary(gender) do
    case gender do
      "male" -> {:ok, true}
      "female" -> {:ok, false}
      _ -> :error
    end
  end

  def cast(_), do: :error

  def load(data) when is_boolean(data) do
    case data do
      true -> {:ok, "male"}
      false -> {:ok, "female"}
    end
  end

  def dump(gender) when is_boolean(gender), do: {:ok, gender}  
  
  def dump(_), do: :error

end