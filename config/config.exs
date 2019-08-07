# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :secret_keeper,
  ecto_repos: [SecretKeeper.Repo]

# Configures the endpoint
config :secret_keeper, SecretKeeperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "z25PmrpQ2SQOmg6QJ+MPyFYSK/wQ9Nkz/XLRb38jD5BOUJ+U+uX2LFQYmVTpYU/t",
  render_errors: [view: SecretKeeperWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SecretKeeper.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian DB for token management
config :guardian, Guardian.DB,
  repo: SecretKeeper.Repo, # Add your repository module
  schema_name: "guardian_tokens", # default
  sweep_interval: 60 # default: 60 minutes

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
