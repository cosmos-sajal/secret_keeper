defmodule SecretKeeper.Services.V1.AuthModule.RegisterService do
  @moduledoc false

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User

  def register_user(%SecretKeeper.ParamsValidation.V1.UserModule.ValidateRegisterData{} = params) do
    with false <- User.does_user_exist(params.email),
         {:ok, %User{}} = {:ok, user} <-
           User.create(Map.from_struct(params)),
         {:ok, tokens} <- Auth.create_tokens(user, params.device_id) do
      {:ok, %{"tokens" => tokens}}
    else
      true ->
        ## User already exists
        {:error, :bad_request, %{message: "User already exists!"}}
    end
  end
end
