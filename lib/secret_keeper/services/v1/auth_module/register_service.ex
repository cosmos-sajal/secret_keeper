defmodule SecretKeeper.Services.V1.AuthModule.RegisterService do
  @moduledoc false

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User
  alias SecretKeeper.Services.V1.AuthModule.TOTPService

  def register_user(%SecretKeeper.ParamsValidation.V1.UserModule.ValidateRegisterData{} = params) do
    with false <- User.does_user_exist(params.email),
         totp_key <- TOTPService.create_key_for_totp(),
         {:ok, %User{}} = {:ok, user} <-
           User.create(Map.from_struct(Map.put(params, :totp_key, totp_key))),
         {:ok, tokens} <- Auth.create_tokens(user, params.device_id) do
      {:ok, %{"tokens" => tokens, "key" => totp_key}}
    else
      true ->
        ## User already exists
        {:error, :bad_request, %{message: "User already exists!"}}
    end
  end
end
