defmodule Db.Repo.Migrations.AlterClientUsersTable do
  use Ecto.Migration

  def change do
    alter table(:client_users) do
      remove :consent
      add :consent, {:array, :integer}
    end
  end
end
