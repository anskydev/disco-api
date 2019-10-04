defmodule Disco.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Disco.Repo, []),
      supervisor(DiscoWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [DiscoWeb.Endpoint])
    ]

    opts = [strategy: :one_for_one, name: Disco.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DiscoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
