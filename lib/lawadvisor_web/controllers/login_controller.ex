defmodule LawadvisorWeb.LoginController do
  use LawadvisorWeb, :controller

  alias Lawadvisor.{Login, Utility}

  action_fallback LawadvisorWeb.FallbackController

  def login(conn, params) do
    params
    |> Login.validate_params()
    |> Login.login_user()
    |> return_result(conn)
  end

  defp return_result({:ok, token}, conn) do
    conn
    |> put_status(200)
    |> render("result.json", result: token)
  end

  defp return_result({:error, changeset}, conn) do
    conn
    |> put_status(400)
    |> render("result.json", result: Utility.transform_error_message(changeset))
  end

end
