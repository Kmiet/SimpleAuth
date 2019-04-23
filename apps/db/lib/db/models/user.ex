defmodule Db.Models.User do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Types.{Gender, Address} 
  alias Db.Models.User

  schema "users" do
    field :email, :string
    field :verified_email, :boolean, default: false
    field :username, :string
    field :first_name, :string
    field :last_name, :string
    field :birth_date, :date
    field :gender, Gender
    field :phone, :string
    field :password, :string
    timestamps()
  end

  def changeset() do
    
  end

end