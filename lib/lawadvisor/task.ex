defmodule Lawadvisor.Task do
  @moduledoc """
  The Task context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Lawadvisor.{
    Data.Task,
    Repo,
    Utility
  }

  def validate_params(params, :add) do
    fields = %{
      task_no: :integer,
      details: :string,
      user_id: :binary_id
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required(:details, message: "Enter task details")
    |> Changeset.validate_number(:task_no, greater_than: 0, message: "Task number is invalid")
    |> Utility.is_valid_changeset?()
  end

  def validate_params(params, :move) do
    fields = %{
      task_no: :integer,
      new_task_no: :integer,
      user_id: :binary_id
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_number(:task_no, greater_than: 0, message: "Task number is invalid")
    |> Changeset.validate_number(:new_task_no, greater_than: 0, message: "New task number is invalid")
    |> validate_new_task_no()
    |> Utility.is_valid_changeset?()
  end

  def validate_params(params, :remove) do
    fields = %{
      task_no: :integer,
      user_id: :binary_id,
      task: :map
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_number(:task_no, greater_than: 0, message: "Task number is invalid")
    |> validate_task_no()
    |> Utility.is_valid_changeset?()
  end

  def validate_params(params, :update) do
    fields = %{
      task_no: :integer,
      details: :string,
      user_id: :binary_id,
      task: :map
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_number(:task_no, greater_than: 0, message: "Task number is invalid")
    |> validate_task_no()
    |> Utility.is_valid_changeset?()
  end

  defp validate_task_no(%{changes: %{task_no: task_no, user_id: user_id}} = changeset) do
    Task
    |> where([t], t.task_no == ^task_no and t.user_id == ^user_id)
    |> limit(1)
    |> Repo.one()
    |> validate_task_no(changeset)
  end
  defp validate_task_no(changeset), do: changeset

  defp validate_task_no(nil, changeset) do
    Changeset.add_error(changeset, :task_no, "Task number does not exist")
  end
  defp validate_task_no(task, changeset) do
    Changeset.put_change(changeset, :task, task)
  end

  defp validate_new_task_no(%{changes: %{task_no: task_no, new_task_no: new_task_no}} = changeset)
    when task_no == new_task_no
  do
    Changeset.add_error(changeset, :message, "Task number and new task number should be different")
  end
  defp validate_new_task_no(changeset), do: changeset

  def view_list(nil), do: {:ok, []}
  def view_list(user_id) do
    tasks =
      Task
      |> where([t], t.user_id == ^user_id)
      |> select([t], %{
        task_no: t.task_no,
        details: t.details
      })
      |> order_by([t], t.task_no)
      |> Repo.all()

    {:ok, tasks}
  end

  def add_task(%{user_id: user_id, details: details} = changes) do
    task_no = changes[:task_no] || 0
    {:ok, result} = Ecto.Adapters.SQL.query(Repo, "
        SELECT * FROM add_task($1, $2, $3)
      ", [user_id, task_no, details]
    )

    result.rows
    |> List.flatten()
    |> List.first()
    |> validate_add_task()
  end
  def add_task(error_changeset), do: error_changeset

  defp validate_add_task("true"), do: {:ok, "Successfully added task"}
  defp validate_add_task(message), do: {:error, %{valid?: false, errors: [task_no: {message, []}]}}

  def move_task(%{user_id: user_id, task_no: task_no, new_task_no: new_task_no}) do
    {:ok, result} = Ecto.Adapters.SQL.query(Repo, "
        SELECT * FROM move_task($1, $2, $3)
      ", [user_id, task_no, new_task_no]
    )

    result.rows
    |> List.flatten()
    |> List.first()
    |> validate_move_task()
  end
  def move_task(error_changeset), do: error_changeset

  defp validate_move_task("true"), do: {:ok, "Successfully moved task"}
  defp validate_move_task(message), do: {:error, %{valid?: false, errors: [message: {message, []}]}}

  def remove_task(%{task: task}) do
    task
    |> Repo.delete()
    |> validate_remove_task()
  end
  def remove_task(error_changeset), do: error_changeset

  defp validate_remove_task({:ok, _task}), do: {:ok, "Successfully removed task"}
  defp validate_remove_task(_result), do: {:error, %{valid?: false, errors: [task_no: {"Error removing task", []}]}}

  def update_task(%{details: details, task: task}) do
    task
    |> Task.changeset(%{details: details})
    |> Repo.update()
    |> validate_update_task()
  end
  def update_task(error_changeset), do: error_changeset

  defp validate_update_task({:ok, _task}), do: {:ok, "Successfully updated task"}
  defp validate_update_task(_result), do: {:error, %{valid?: false, errors: [task_no: {"Error updating task", []}]}}

  def insert_task(task) do
    %Task{}
    |> Task.changeset(task)
    |> Repo.insert!()
    |> Utility.struct_to_map([:task_no, :details])
  end

end
