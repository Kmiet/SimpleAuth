defmodule Db.Models.Identity do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Models.Identity
  alias Db.Models.Provider

  schema "indenties" do
    field :verified_user, :boolean, default: false
    field :data, :map
  end

  def changeset() do
    
  end

end