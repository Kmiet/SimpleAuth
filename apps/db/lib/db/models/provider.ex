defmodule Db.Models.Provider do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Models.Provider

  schema "indenties" do
    field :name, :string
  end

  def changeset() do
    
  end

end