defmodule Lawadvisor.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lawadvisor.User` context.
  """

  @doc """
  Generate a user.
  """
  def create_user(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        username: "joeffreygarcia",
        password: "P@ssw0rd"
      })
      |> Lawadvisor.Register.register_user()

    %{username: user.username, password: user.password, user_id: user.id}
  end
end
