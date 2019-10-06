use Mix.Config

config :pbkdf2_elixir, :rounds, 1

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :disco, DiscoWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :disco, Disco.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "disco_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
