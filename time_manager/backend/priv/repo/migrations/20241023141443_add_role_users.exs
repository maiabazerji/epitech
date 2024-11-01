defmodule TimeManager.Repo.Migrations.AddRoleUsers do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :role, :string, default: "user"
    end

    create index(:users, [:role])
  end

  def down do
    alter table(:users) do
      remove :role
    end

    drop index(:users, [:role])
  end
end
