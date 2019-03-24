defmodule Db.Models.User do
  use Ecto.Schema
  import Ecto.Query

  alias Db.Repo
  alias Db.Models.User

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :data, :map
  end

  def changeset() do
    
  end

end