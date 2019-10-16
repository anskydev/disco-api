defmodule Disco.Mixfile do
  use Mix.Project

  def project do
    [
      app: :disco,
      version: "0.0.1",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Disco.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "dev/support", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "dev/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:dataloader, "~> 1.0.6"},
      {:comeonin_ecto_password, "~> 2.2.0"},
      {:argon2_elixir, "~> 1.3.0"},
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:phoenix_ecto, "~> 3.6.0"},
      {:decimal, "~> 1.8.0"},
      {:postgrex, ">= 0.13.5"},
      {:phoenix_html, "~> 2.13.3"},
      {:phoenix_live_reload, "~> 1.1.7", only: :dev},
      {:gettext, "~> 0.17.0"},
      {:cowboy, "~> 1.0.0"},
      {:plug_cowboy, "~> 1.0.0"},
      {:absinthe, "~> 1.4.16"},
      {:jason, "~> 1.0.0"},
      {:absinthe_plug, "~> 1.4.7"},
      {:absinthe_phoenix, "~> 1.4.3"},
      {:absinthe_relay, "~> 1.4.6"},
      {:mailgun, "~> 0.1.2"},
      {:poison, "~> 2.1", override: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
