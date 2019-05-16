defmodule Db.Models.ClientUser do
    use Db.Schema
    import Ecto.Changeset
  
    alias Db.Repo
    alias Db.Models.{User, Client}
  
    @primary_key false
    schema "client_users" do
      field :is_banned, :boolean, default: false
      field :banned_due, :naive_datetime
      field :consent, :boolean, default: false
      timestamps([type: :utc_datetime])
  
      belongs_to :user, User
      belongs_to :client, Client
    end
  
    def changeset() do
      
    end
  
  end