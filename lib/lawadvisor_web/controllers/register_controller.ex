defmodule LawadvisorWeb.RegisterController do
  use LawadvisorWeb, :controller

  alias Lawadvisor.{Register, Utility}

  action_fallback LawadvisorWeb.FallbackController

  def register(conn, params) do
    params
    |> Register.validate_params()
    |> Register.register_user()
    |> return_result(conn)
  end

  defp return_result({:ok, _user}, conn) do
    conn
    |> put_status(200)
    |> render("result.json", result: "User registered successfully")
  end

  defp return_result({:error, changeset}, conn) do
    conn
    |> put_status(400)
    |> render("result.json", result: Utility.transform_error_message(changeset))
  end

end
