defmodule Db.Models.Session do
  use Db.Schema

  import Ecto.Query
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Models.{User}

  schema "sessions" do
    field :begin_time, :utc_datetime
    field :end_time, :utc_datetime
    field :is_active, :boolean, default: true

    belongs_to :owner, User
  end

  def changeset() do
    
  end

end