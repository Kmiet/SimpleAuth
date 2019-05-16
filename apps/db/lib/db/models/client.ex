defmodule Db.Models.Client do
  use Db.Schema
  import Ecto.Changeset

  alias Db.Repo
  alias Db.Types.{DbURI, Flow, UserScope}
  alias Db.Models.User

  schema "clients" do
    field :name, :string
    field :secret, :string
    field :flow, Flow
    field :logo_uri, DbURI
    field :style_uri, DbURI
    field :access_config, :map
    field :user_scopes, {:array, UserScope}
    field :login_redirects, {:array, DbURI}
    field :logout_redirects, {:array, DbURI}
    timestamps([type: :utc_datetime])

    belongs_to :owner, User
  end

  def changeset() do
    
  end

end