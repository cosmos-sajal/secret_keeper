defmodule SecretKeeper.HelperModule.EmailHelper do
  @moduledoc """
  Contains helper functions for validation of email_id
  """

  use SecretKeeper, :model

  @doc """
  Validates the email id

  ## Parameters
    - changeset: struct
    - key: atom
  """
  def validate_email(changeset, key \\ :email) do
    changeset
    |> validate_format(key, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]{2,5}$/)
  end
end
