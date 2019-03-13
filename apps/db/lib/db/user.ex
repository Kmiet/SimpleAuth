defmodule Db.User do
  use Ecto.Schema
  import Ecto.Query

  alias Db.Repo
  alias Db.User

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :data, :map
  end

  def add(email, password) do
    Repo.insert %User{email: email, password: password}
  end

  def findOne(email, params \\ %{}) do
    Repo.one from u in User, where: u.email == ^email
  end

  def findAll do
    Repo.all from u in User
  end

end