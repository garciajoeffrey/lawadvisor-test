import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :lawadvisor, Lawadvisor.Repo,
  username: "postgres",
  password: "postgres",
  database: "lawadvisor_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10,
  migration_primary_key: [name: :uuid, type: :binary_id]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :lawadvisor, LawadvisorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "t+8HwA+3IE5azZEG1RGxxARC2zdqdNeUVhuR+k/Z0+MdaU4/ZYla5mGPcuG4gjB7",
  server: false

# In test we don't send emails.
config :lawadvisor, Lawadvisor.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
