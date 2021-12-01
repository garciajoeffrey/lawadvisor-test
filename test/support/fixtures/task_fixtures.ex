defmodule Lawadvisor.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lawadvisor.Task` context.
  """

  @doc """
  Generate a task.
  """
  def create_tasks(user_id) do
    params = [%{
      user_id: user_id,
      task_no: "1",
      details: "Example Task 1"
    },
    %{
      user_id: user_id,
      task_no: "2",
      details: "Example Task 2"
    },
    %{
      user_id: user_id,
      task_no: "3",
      details: "Example Task 3"
    },
    %{
      user_id: user_id,
      task_no: "4",
      details: "Example Task 4"
    }]

    Enum.map(params, &(Lawadvisor.Task.insert_task(&1)))
  end

end
