defmodule SecretKeeper.Auth.Auth do
  @moduledoc false

  alias SecretKeeper.Repo
  alias SecretKeeper.Auth.Guardian
  alias SecretKeeper.Schemas.V1.User
  alias SecretKeeper.Auth.ExpiryHelper

  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2]

  @doc """
  Verifies the mobile number and password given for login

  ## Parameters
    - mobile_number: string
    - password: string
  """
  def password_sign_in(email, password) do
    with %User{} = user <- User.get_user_by_email(email),
         do: verify_password(password, user)
  end

  def get_user_from_jwt(conn) do
    with user <- Guardian.Plug.current_resource(conn) do
      user
    else
      _ ->
        {:error, :unauthorized}
    end
  end

  def destroy_device_sessions(device_id, subject) do
    query =
      from(token in "guardian_tokens",
        where:
          fragment(
            """
            cast(claims->>'sub' as varchar) = ? and
            cast(claims->>'device_id' as varchar) = ?
            """,
            ^subject,
            ^device_id
          )
      )

    ##  Returns {count, data}, where count is the number
    ##  items deleted.
    ##  Case {0, _} for Repo.delete! wont happen since
    ##  the auth plug
    ##  would throw "Invalid Token" error if the token
    ##  does not exist in the guardian DB
    {count, _} = query |> Repo.delete_all()

    {:ok, count}
  end

  def create_tokens(resource, device_id) do
    claims = %{
      sub: resource.id,
      device_id: device_id
    }

    with {:ok, access_token} <- create_token(resource, claims, "access"),
         {:ok, refresh_token} <- create_token(resource, claims, "refresh") do
      tokens = %{
        access_token: access_token,
        refresh_token: refresh_token,
        access_token_expires_at: ExpiryHelper.get_token_expiry(),
        refresh_token_expires_at: ExpiryHelper.get_token_expiry()
      }

      {:ok, tokens}
    end
  end

  defp verify_password(password, user) when is_binary(password) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :unauthorized, %{message: "Password doesn't match"}}
    end
  end

  defp create_token(resource, claims, type) do
    {:ok, token, _claims} = Guardian.encode_and_sign(resource, claims, token_type: type)

    {:ok, token}
  end
end
