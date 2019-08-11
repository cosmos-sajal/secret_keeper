defmodule SecretKeeper.Services.V1.AuthModule.LoginService do
  @moduledoc false

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User
  alias SecretKeeper.Services.V1.AuthModule.TOTPService
  alias SecretKeeper.Services.V1.CryptographyModule.CryptographyService

  def login_user(%SecretKeeper.ParamsValidation.V1.UserModule.ValidateLoginData{} = params) do
    %{email: email, password: password, device_id: device_id, token: token} = params

    with {:ok, user} <- Auth.password_sign_in(email, password),
         totp_key <- CryptographyService.decrypt(user.totp_key, password),
         true <- TOTPService.check_token(totp_key, token),
         {:ok, tokens} <- Auth.create_tokens(user, device_id) do
      {:ok, %{"tokens" => tokens}}
    else
      nil ->
        {:error, :not_found, %{message: "User not found"}}

      false ->
        {:error, :unauthorized, %{message: "Unauthorised access, wrong token"}}

      {:error, code, message} ->
        {:error, code, message}
    end
  end
end
