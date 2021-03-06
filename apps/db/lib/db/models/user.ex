defmodule Db.Models.User do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Types.Gender
  alias Db.Models.User

  @derive {Jason.Encoder, except: [:__meta__]}
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
    timestamps([type: :utc_datetime])
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :email, 
      :verified_email, 
      :username, :first_name, 
      :last_name, 
      :birth_date, 
      :gender,
      :phone,
      :password
    ])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp hash_password(password) do

  end

end