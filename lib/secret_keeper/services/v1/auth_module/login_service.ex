defmodule SecretKeeper.Services.V1.AuthModule.LoginService do
  @moduledoc false

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User

  def login_user(%SecretKeeper.ParamsValidation.V1.UserModule.ValidateLoginData{} = params) do
    %{email: email, password: password, device_id: device_id} = params

    with {:ok, user} <- Auth.password_sign_in(email, password),
         {:ok, tokens} <- Auth.create_tokens(user, device_id) do
      {:ok, %{"tokens" => tokens}}
    else
      nil ->
        {:error, :not_found, %{message: "User not found"}}

      {:error, code, message} ->
        {:error, code, message}
    end
  end
end
