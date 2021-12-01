defmodule Lawadvisor.Repo do
  use Ecto.Repo,
    otp_app: :lawadvisor,
    adapter: Ecto.Adapters.Postgres
end
