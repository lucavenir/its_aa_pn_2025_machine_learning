defmodule AiQuizzer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AiQuizzerWeb.Telemetry,
      AiQuizzer.Repo,
      {DNSCluster, query: Application.get_env(:ai_quizzer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AiQuizzer.PubSub},
      # Start a worker by calling: AiQuizzer.Worker.start_link(arg)
      # {AiQuizzer.Worker, arg},
      # Start to serve requests, typically the last entry
      AiQuizzerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiQuizzer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiQuizzerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
