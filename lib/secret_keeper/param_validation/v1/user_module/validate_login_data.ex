defmodule SecretKeeper.ParamsValidation.V1.UserModule.ValidateLoginData do
  @moduledoc """
  Parameter validation for POST /api/v1/user/register
  """

  use SecretKeeperWeb, :params

  alias SecretKeeper.HelperModule, as: Helper

  @cast_params [
    :email,
    :password,
    :device_id,
    :token
  ]

  @primary_key false
  embedded_schema do
    field(:email, :string, null: false)
    field(:password, :string, null: false)
    field(:device_id, :string, null: false)
    field(:token, :string, null: false)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(@cast_params)
    |> Helper.DeviceIdHelper.validate()
  end
end
