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
      timestamps([type: :utc_datetime])
    end

    create table(:clients) do
      add :name, :string
      add :secret, :string
      add :flow, :integer
      add :logo_uri, :string
      add :style_uri, :string
      add :access_config, :map
      add :user_scopes, {:array, :integer}
      add :login_redirects, {:array, :string}
      add :logout_redirects, {:array, :string}
      timestamps([type: :utc_datetime])
      add :owner_id, references("users", on_delete: :delete_all)
    end

    create table(:identities) do
      add :sub, :string
      add :provider, :string
      add :verified_email, :boolean, default: false
      add :owner_id, references("users", on_delete: :delete_all)
    end

    create table(:sessions) do
      add :begin_time, :utc_datetime, default: fragment("(now() at time zone 'utc')")
      add :end_time, :utc_datetime
      add :is_active, :boolean, default: true
      add :owner_id, references("users", on_delete: :delete_all)
    end

    create table(:client_users, primary_key: false) do
      add :is_banned, :boolean, default: false
      add :banned_due, :naive_datetime
      add :consent, :boolean, default: false
      timestamps([type: :utc_datetime])
      add :user_id, references("users", on_delete: :delete_all)
      add :client_id, references("clients", on_delete: :delete_all)
    end

    create table(:client_sessions, primary_key: false) do
      add :begin_times, {:array, :utc_datetime}
      add :end_times, {:array, :utc_datetime}
      add :is_active, :boolean, default: true
      add :session_id, references("sessions", on_delete: :delete_all)
      add :client_id, references("clients", on_delete: :delete_all)
    end

    create index("users", [:email], unique: true)
    create index("identities", [:sub, :provider], unique: true)
    create index("client_users", [:client_id, :user_id], unique: true)
    create index("client_sessions", [:client_id, :session_id], unique: true)
  end
end
