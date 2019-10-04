# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :comeonin, Ecto.Password, Comeonin.Pbkdf2

# General application configuration
config :disco,
  ecto_repos: [Disco.Repo]

# Configures the endpoint
config :disco, DiscoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JbSS+mF2qR3w+3PdYK4g4uBwTA48ZGF6sHpkt0tynRf4EIyrMp0aPb1CAmMgkrkL",
  render_errors: [view: DiscoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Disco.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
