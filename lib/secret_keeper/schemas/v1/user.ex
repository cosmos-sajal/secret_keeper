defmodule SecretKeeper.Schemas.V1.User do
  @moduledoc """
  """
  use SecretKeeper, :model

  alias SecretKeeper.HelperModule.EmailHelper

  @cast_params [
    :name,
    :email,
    :password,
    :password_confirmation
  ]

  schema "users" do
    field(:name, :string, null: false)
    field(:email, :string, null: true)
    field(:is_email_verified, :boolean, default: false)
    field(:password_hash, :string, null: false)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    soft_delete_schema()
    uuid_schema()
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @cast_params)
    |> validate_required(@cast_params)
    |> EmailHelper.validate_email()
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
