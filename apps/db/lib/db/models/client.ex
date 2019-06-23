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

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [
      :name, 
      :secret, 
      :flow, 
      :logo_uri, 
      :style_uri, 
      :access_config,
      :user_scopes,
      :login_redirects,
      :logout_redirects,
      :owner_id
    ])
    |> validate_required([
      :login_redirects, 
      :name, 
      :owner_id, 
      :secret, 
      :user_scopes
    ])
  end

end