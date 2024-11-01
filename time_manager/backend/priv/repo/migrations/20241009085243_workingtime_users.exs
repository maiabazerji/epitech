defmodule TimeManager.Repo.Migrations.WorkingtimeUsers do
  use Ecto.Migration

  def up do
    alter table(:workingtimes) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end

  def down do
    alter table(:workingtimes) do
      remove :user_id
    end
  end
end
