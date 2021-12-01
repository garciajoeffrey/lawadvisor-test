defmodule Lawadvisor.Data.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias Lawadvisor.Data.User

  @primary_key {:id, :binary_id, [autogenerate: true]}
  schema "users" do
    field :username, :string
    field :password, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end
end
