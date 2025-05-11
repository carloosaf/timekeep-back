defmodule Timekeep.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimekeepWeb.Telemetry,
      Timekeep.Repo,
      TimekeepWeb.Auth.JwksStrategy,
      {DNSCluster, query: Application.get_env(:timekeep, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Timekeep.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Timekeep.Finch},
      # Start a worker by calling: Timekeep.Worker.start_link(arg)
      # {Timekeep.Worker, arg},
      # Start to serve requests, typically the last entry
      TimekeepWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Timekeep.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimekeepWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
