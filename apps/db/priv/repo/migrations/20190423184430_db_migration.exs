defmodule Db.Repo.Migrations.DbMigration do
  use Ecto.Migration

  def change do
    create_if_not_exist table(:users) do
      add :email, :string
      add :verified_email, :boolean, default: false
      add :username, :string
      add :first_name, :string
      add :last_name, :string
      add :birth_date, :date
      add :gender, Gender
      add :phone, :string
      add :password, :string
      timestamps
    end

    create_if_not_exist table(:clients) do
      add :name, :string
      add :secret, :string
      add :logo_uri, DbURI
      add :style_uri, DbURI
      add :access_config, :map
      add :user_scopes, {:array, UserScope}
      add :login_redirects, {:array, DbURI}
      add :logout_redirects, {:array, DbURI}
      timestamps
      add :owner_id, refencers("users")
    end

    create_if_not_exist table(:identities) do
      add :sub, :string
      add :provider, :string
      add :verified_email, :boolean, default: false
      add :owner_id, refencers("users")
    end

    create_if_not_exist table(:clients_users) do
      add :is_banned, :boolean, default: false
      add :banned_due, :naive_datetime
      add :consent, :boolean, default: false
      timestamps()
      add :user_id, refencers("users")
      add :client_id, refencers("clients")
    end
  end
end
