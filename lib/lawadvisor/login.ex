defmodule Lawadvisor.Login do
  @moduledoc """
  The Login context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Lawadvisor.{
    Data.User,
    Plug.Auth,
    Repo,
    Utility
  }

  def validate_params(params \\ %{}) do
    fields = %{
      username: :string,
      password: :string,
      user_id: :binary_id
    }

    {%{}, fields}
    |> Changeset.cast(params, Map.keys(fields))
    |> Changeset.validate_required(:username, message: "Enter username")
    |> Changeset.validate_required(:password, message: "Enter password")
    |> validate_user()
    |> Utility.is_valid_changeset?()
  end

  defp validate_user(%{changes: %{username: username}} = changeset) do
    User
    |> Repo.get_by(username: username)
    |> validate_user_exist(changeset)
  end
  defp validate_user(changeset), do: changeset

  defp validate_user_exist(nil, changeset) do
    Changeset.add_error(changeset, :username, "Username does not exist")
  end
  defp validate_user_exist(user, %{changes: %{password: pass}} = changeset)
    when user.password == pass do
      Changeset.put_change(changeset, :user_id, user.id)
  end
  defp validate_user_exist(_user, changeset) do
    Changeset.add_error(changeset, :password, "Invalid password. Please try again.")
  end

  def login_user(%{user_id: user_id}) do
    token = Auth.generate_token(user_id)
    {:ok, %{access_token: token}}
  end
  def login_user(error_changeset), do: error_changeset

end
