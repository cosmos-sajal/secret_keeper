defmodule SecretKeeper.Services.V1.AuthModule.LogoutService do
  @moduledoc false

  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User

  def logout_user(
        %SecretKeeper.ParamsValidation.V1.UserModule.ValidateLogoutData{} = params,
        claims
      ) do
    %{device_id: device_id} = params
    subject = Map.get(claims, "sub")
    claims_device_id = Map.get(claims, "device_id")

    with true <- device_id == claims_device_id,
         {:ok, _count} <- Auth.destroy_device_sessions(device_id, subject) do
      {:ok, %{message: "Logout sucessful"}}
    else
      false ->
        {:error, :forbidden, %{message: "Not authorised for this action"}}

      {:error, code, message} ->
        {:error, code, message}
    end
  end
end
