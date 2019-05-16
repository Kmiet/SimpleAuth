defmodule Db.Models.ClientSesison do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Models.{Session, Client}

  @primary_key false
  schema "client_sessions" do
    field :begin_times, {:array, :utc_datetime}
    field :end_times, {:array, :utc_datetime}
    field :is_active, :boolean, default: true

    belongs_to :session, Session
    belongs_to :client, Client
  end

  def changeset() do
    
  end

end