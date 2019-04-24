defmodule Db.Repo.Migrations.DbMigration do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :verified_email, :boolean, default: false
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :birth_date, :date
      add :gender, :boolean
      add :phone, :string
      add :password, :string
      timestamps()
    end

    create table(:clients) do
      add :name, :string
      add :secret, :string
      add :logo_uri, :string
      add :style_uri, :string
      add :access_config, :map
      add :user_scopes, {:array, :integer}
      add :login_redirects, {:array, :string}
      add :logout_redirects, {:array, :string}
      timestamps()
      add :owner_id, references("users", on_delete: :delete_all)
    end

    create table(:identities) do
      add :sub, :string
      add :provider, :string
      add :verified_email, :boolean, default: false
      add :owner_id, references("users", on_delete: :delete_all)
    end

    create table(:client_users, primary_key: false) do
      add :is_banned, :boolean, default: false
      add :banned_due, :naive_datetime
      add :consent, :boolean, default: false
      timestamps()
      add :user_id, references("users", on_delete: :delete_all)
      add :client_id, references("clients", on_delete: :delete_all)
    end

    create index("users", [:email], unique: true)
    create index("identities", [:sub, :provider], unique: true)
    create index("client_users", [:client_id, :user_id], unique: true)
  end
end
