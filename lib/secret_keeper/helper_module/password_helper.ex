defmodule SecretKeeper.HelperModule.PasswordHelper do
  @moduledoc """
  Contains helper functions for validation of password
  """

  use SecretKeeper, :model

  @doc """
  Validates the password

  ## Parameters
    - changeset: struct
    - key: atom
  """
  def validate(changeset, key \\ :password) do
    if changeset.valid? do
      changeset
      |> validate_format(
        key,
        ~r/^.*(?=.{8,})((?=.*[!@#$%^&*()\-_=+{};:,<.>]){1})(?=.*\d)((?=.*[a-z]){1})((?=.*[A-Z]){1}).*$/
      )
      |> send_response()
    else
      changeset
    end
  end

  def send_response(changeset) do
    if changeset.valid? do
      changeset
    else
      add_error(
        changeset,
        :password,
        "Password should contain at least 1 upper case, at least 1 lower case, at least 1 special character, at least 1 numeric,must be at least 8 characters long"
      )
    end
  end
end
