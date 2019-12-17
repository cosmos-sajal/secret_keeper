defmodule SecretKeeper.Application do
  @moduledoc false

  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SecretKeeper.Repo, []),
      # Start the endpoint when the application starts
      supervisor(SecretKeeperWeb.Endpoint, []),
      # Start your own worker by calling: SecretKeeper.Worker.start_link(arg1, arg2, arg3)
      # worker(SecretKeeper.Worker, [arg1, arg2, arg3]),
      {Guardian.DB.Token.SweeperServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SecretKeeper.Supervisor]
    Supervisor.start_link(children, opts)

    # Get Redix configuration
    host = Application.get_env(:secret_keeper, :redis_host)
    port = Application.get_env(:secret_keeper, :redis_port)
    database = Application.get_env(:secret_keeper, :redis_database)
    # Start redix connection
    {:ok, redis_conn} = Redix.start_link("redis://#{host}:#{port}/#{database}", name: :redix)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SecretKeeperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
