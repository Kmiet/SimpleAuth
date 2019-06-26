defmodule Db.Models.ClientUser do
    use Db.Schema
    import Ecto.Changeset
  
    alias Db.Repo
    alias Db.Models.{User, Client}
    alias Db.Types.UserScope
  
    @primary_key false
    schema "client_users" do
      field :is_banned, :boolean, default: false
      field :banned_due, :naive_datetime
      field :consent, {:array, UserScope}
      timestamps([type: :utc_datetime])
  
      belongs_to :user, User
      belongs_to :client, Client
    end
  
    def changeset(client_user, params \\ %{}) do
      client_user
      |> cast(params, [
        :is_banned, 
        :banned_due, 
        :consent, 
        :user_id, 
        :client_id
      ])
      |> validate_required([
        :consent,
        :user_id, 
        :client_id
      ])
    end
  
  end