defmodule Lawadvisor.Repo.Migrations.CreateTasksTable do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true, null: false
      add :task_no, :integer
      add :details, :string
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end
  end
end
