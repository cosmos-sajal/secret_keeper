defmodule SecretKeeperWeb.Api.V1.AuthModule.AuthController do
  @moduledoc false

  use SecretKeeperWeb, :controller

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User
  alias SecretKeeper.Services.V1.AuthModule.LoginService
  alias SecretKeeper.Services.V1.AuthModule.LogoutService
  alias SecretKeeper.Services.V1.AuthModule.RegisterService

  action_fallback(SecretKeeperWeb.Api.V1.FallbackController)

  plug(
    SecretKeeper.ParamsValidation.V1.UserModule.ValidateRegisterData,
    :validate_register_data when action in [:register]
  )

  plug(
    SecretKeeper.ParamsValidation.V1.UserModule.ValidateLoginData,
    :validate_login_data when action in [:login]
  )

  plug(
    SecretKeeper.ParamsValidation.V1.UserModule.ValidateLogoutData,
    :validate_logout_data when action in [:logout]
  )

  def register(conn, params) do
    with validated_params <- conn.assigns.validate_register_data,
         {:ok, response} <- RegisterService.register_user(validated_params) do
      conn
      |> json(response)
    end
  end

  def login(conn, params) do
    with validated_params <- conn.assigns.validate_login_data,
         {:ok, response} <- LoginService.login_user(validated_params) do
      conn
      |> json(response)
    end
  end

  def logout(conn, params) do
    with validated_params <- conn.assigns.validate_logout_data,
         claims <- Guardian.Plug.current_claims(conn),
         {:ok, response} <- LogoutService.logout_user(validated_params, claims) do
      conn
      |> json(response)
    end
  end
end
