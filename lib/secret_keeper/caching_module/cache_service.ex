defmodule SecretKeeper.CachingModule.CacheService do
  @moduledoc """
  An adapter for cache service - Redix
  """

  def set(key, value) do
    Redix.command(:redix, ["SET", key, value])
  end

  def get(key) do
    Redix.command(:redix, ["GET", key])
  end
end
