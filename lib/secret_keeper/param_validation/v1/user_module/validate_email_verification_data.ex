defmodule SecretKeeper.ParamsValidation.V1.UserModule.ValidateEmailVerificationData do
  @moduledoc """
  Parameter validation for PATCH /api/v1/validate/user/email
  """

  use SecretKeeperWeb, :params

  alias SecretKeeper.HelperModule, as: Helper

  @cast_params [
    :txn_id,
    :type
  ]

  @primary_key false
  embedded_schema do
    field(:txn_id, :string, null: false)
    field(:type, :string, null: false)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @cast_params)
    |> validate_required(@cast_params)
    |> Helper.UUIDHelper.validate(params["txn_id"])
  end
end
