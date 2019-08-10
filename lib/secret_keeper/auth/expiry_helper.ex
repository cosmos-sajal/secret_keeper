defmodule SecretKeeper.Auth.ExpiryHelper do
  @moduledoc """
  Consists of helper functions for auth token resource
  """

  @expiry_map %{
    second: 1,
    seconds: 1,
    minute: 60,
    minutes: 60,
    hour: 3600,
    hours: 3600,
    day: 3600 * 24,
    days: 3600 * 24,
    week: 3600 * 24 * 7,
    weeks: 3600 * 24 * 7
  }

  @doc """
  Returns the Unix timestamp at which the token would expire.
  """
  def get_token_expiry do
    {time, unit} = Application.get_env(:secret_keeper, SecretKeeper.Auth.Guardian)[:ttl]

    DateTime.utc_now()
    |> DateTime.add(@expiry_map[unit] * time, :second)
    |> DateTime.to_iso8601()
  end
end
