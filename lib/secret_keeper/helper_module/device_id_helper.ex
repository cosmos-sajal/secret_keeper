defmodule SecretKeeper.HelperModule.DeviceIdHelper do
  @moduledoc """
  Contains helper functions for device_id
  """

  use SecretKeeperWeb, :params

  @doc """
  Validates the device_id
   ## Parameters
    - changeset: struct
  """
  def validate(changeset, key \\ :device_id) do
    if changeset.valid? do
      changeset
      |> validate_format(key, ~r/^[a-z A-Z 0-9\_\-\:]+$/)
    else
      changeset
    end
  end
end
