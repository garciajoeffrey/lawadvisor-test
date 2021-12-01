defmodule LawadvisorWeb.TaskController do
  use LawadvisorWeb, :controller
  plug :can_access?

  alias Lawadvisor.{Task, Utility}

  action_fallback LawadvisorWeb.FallbackController

  def view(%{assigns: %{current_user: user}} = conn, _params) do
    user
    |> Task.view_list()
    |> return_view_result(conn)
  end
  def view(conn, _params), do: return_result(:invalid, conn)

  def add(%{assigns: %{current_user: user}} = conn, params) do
    params
    |> update_params(user)
    |> Task.validate_params(:add)
    |> Task.add_task()
    |> return_result(conn)
  end
  def add(conn, _params), do: return_result(:invalid, conn)

  def remove(%{assigns: %{current_user: user}} = conn, params) do
    params
    |> update_params(user)
    |> Task.validate_params(:remove)
    |> Task.remove_task()
    |> return_result(conn)
  end
  def remove(conn, _params), do: return_result(:invalid, conn)

  def update(%{assigns: %{current_user: user}} = conn, params) do
    params
    |> update_params(user)
    |> Task.validate_params(:update)
    |> Task.update_task()
    |> return_result(conn)
  end
  def update(conn, _params), do: return_result(:invalid, conn)

  def move(%{assigns: %{current_user: user}} = conn, params) do
    params
    |> update_params(user)
    |> Task.validate_params(:move)
    |> Task.move_task()
    |> return_result(conn)
  end
  def move(conn, _params), do: return_result(:invalid, conn)

  defp update_params(params, user), do: Map.put(params, "user_id", user)

  defp return_view_result({:ok, []}, conn) do
    conn
    |> put_status(200)
    |> render("result.json", result: %{message: "No tasks to be viewed for this user"})
  end

  defp return_view_result({:ok, tasks}, conn) do
    conn
    |> put_status(200)
    |> render("result.json", result: %{tasks: tasks})
  end

  defp return_result({:ok, tasks}, conn) do
    conn
    |> put_status(200)
    |> render("result.json", result: %{message: tasks})
  end

  defp return_result({:error, changeset}, conn) do
    conn
    |> put_status(400)
    |> render("result.json", result: Utility.transform_error_message(changeset))
  end

  defp return_result(:invalid, conn) do
    conn
    |> put_status(401)
    |> render("result.json", result: "Unauthorized")
  end

end
