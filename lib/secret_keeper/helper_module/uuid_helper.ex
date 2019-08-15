defmodule SecretKeeper.HelperModule.UUIDHelper do
  @moduledoc """
  Contains helper functions for uuid
  """
  use SecretKeeperWeb, :params

  @doc """
  Validates the uuid
   ## Parameters
    - changeset: struct
  """
  def validate(changeset, value, key \\ :uuid) do
    case Ecto.UUID.dump(value) do
      :error ->
        changeset
        |> add_error(key, "Invalid uuid")

      _ ->
        changeset
    end
  end
end
