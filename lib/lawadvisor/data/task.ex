defmodule Lawadvisor.Data.Task do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Lawadvisor.Data.Task

  @primary_key {:id, :binary_id, [autogenerate: true]}
  schema "tasks" do
    field :task_no, :integer
    field :details, :string

    belongs_to(:user, Lawadvisor.Data.User, type: :binary_id)
    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:user_id, :task_no, :details])
    |> validate_required([:user_id, :task_no, :details])
  end
end
