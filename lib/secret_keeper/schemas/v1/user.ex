defmodule SecretKeeper.Schemas.V1.User do
  @moduledoc """
  """
  use SecretKeeper, :model

  alias SecretKeeper.HelperModule.EmailHelper

  @cast_params [
    :name,
    :email,
    :password,
    :password_confirmation,
    :totp_key
  ]

  schema "users" do
    field(:name, :string, null: false)
    field(:email, :string, null: true)
    field(:is_email_verified, :boolean, default: false)
    field(:password_hash, :string, null: false)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:totp_key, :string, null: false)

    soft_delete_schema()
    uuid_schema()
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, @cast_params)
    |> validate_required(@cast_params)
    |> EmailHelper.validate()
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> put_password_hash()
  end

  def get_by_id(id) do
    Repo.get_by(__MODULE__, %{id: id, is_deleted: false})
  end

  def get_user_by_email(email) do
    Repo.get_by(__MODULE__, %{email: email, is_deleted: false})
  end

  def does_user_exist(email) do
    case Repo.get_by(__MODULE__, %{email: email, is_deleted: false}) do
      nil -> false
      %__MODULE__{} -> true
    end
  end

  def create(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
