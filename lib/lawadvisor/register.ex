defmodule Lawadvisor.Register do
  @moduledoc """
  The Register context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Lawadvisor.{
    Data.User,
    Repo,
    Utility
  }

  def validate_params(params \\ %{}) do
    fields = %{
      username: :string,
      password: :string
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

  defp validate_user_exist(nil, changeset), do: changeset
  defp validate_user_exist(_user, changeset) do
    Changeset.add_error(changeset, :username, "Username already exists")
  end

  def register_user({:error, _changeset} = x), do: x
  def register_user(changes) do
    %User{}
    |> User.changeset(changes)
    |> Repo.insert()
  end

end
