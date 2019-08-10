defmodule SecretKeeper.ParamsValidation.V1.UserModule.ValidateRegisterData do
  @moduledoc """
  Parameter validation for POST /api/v1/user/register
  """

  use SecretKeeperWeb, :params

  alias SecretKeeper.HelperModule, as: Helper

  @cast_params [
    :name,
    :email,
    :password,
    :password_confirmation,
    :device_id
  ]

  @primary_key false
  embedded_schema do
    field(:name, :string, null: false)
    field(:email, :string, null: false)
    field(:password, :string, null: false)
    field(:password_confirmation, :string, null: false)
    field(:device_id, :string, null: false)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(@cast_params)
    |> Helper.PasswordHelper.validate()
    |> validate_confirmation(:password)
    |> Helper.EmailHelper.validate()
    |> Helper.DeviceIdHelper.validate()
  end
end
