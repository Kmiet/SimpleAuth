defmodule Db.Models.Identity do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Models.{Identity, User}

  schema "indenties" do
    field :sub, :string
    field :provider, :string
    field :verified_email, :boolean, default: false

    belongs_to :user, User
  end

  def changeset() do
    
  end

end