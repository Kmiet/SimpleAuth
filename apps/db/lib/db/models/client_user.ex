defmodule Db.Models.ClientUser do
    use Db.Schema
    import Ecto.Changeset
  
    alias Db.Repo
    alias Db.Models.{User, Client}
  
    schema "client_user" do
      field :is_banned, :boolean, default: false
      field :banned_due, :naive_datetime
      field :consent, :boolean, default: false
      timestamps()
  
      belongs_to :user, User
      belongs_to :client, Client
    end
  
    def changeset() do
      
    end
  
  end