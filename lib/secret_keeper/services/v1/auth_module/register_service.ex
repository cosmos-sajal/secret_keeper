defmodule SecretKeeper.Services.V1.AuthModule.RegisterService do
  @moduledoc false

  alias SecretKeeper.Schemas.V1.User
  alias SecretKeeper.MailerModule.Mailer
  alias SecretKeeper.ModelHelpers.UUID.Schema, as: UUID
  alias SecretKeeper.CachingModule.CacheService
  alias SecretKeeper.Services.V1.AuthModule.TOTPService
  alias SecretKeeper.Services.V1.CryptographyModule.CryptographyService

  @email_verification_type "email_verification"

  def register_user(%SecretKeeper.ParamsValidation.V1.UserModule.ValidateRegisterData{} = params) do
    with false <- User.does_user_exist(params.email),
         totp_key <- TOTPService.create_key_for_totp(),
         encrypted_totp_key <- CryptographyService.encrypt(totp_key, params.password),
         {:ok, %User{}} = {:ok, user} <-
           User.create(Map.from_struct(Map.put(params, :totp_key, encrypted_totp_key))),
         {:ok, email_verification_key} <- create_txn_id_for_email_confirmation(user) do
      ## send email
      link =
        "#{SecretKeeperWeb.Endpoint.url()}/api/v /validate/user/email?#{email_verification_key}"

      Mailer.send_email_verification_mail(user.email, link)

      {:ok,
       %{
         "key" => totp_key,
         "message" =>
           "Email verificaiton link is sent to your registered email, please verify before proceeding"
       }}
    else
      true ->
        ## User already exists
        {:error, :bad_request, %{message: "User already exists!"}}
    end
  end

  def validate_email(
        %SecretKeeper.ParamsValidation.V1.UserModule.ValidateEmailVerificationData{} = params
      ) do
    %{txn_id: txn_id, type: type} = params
    cache_key = "txn_id=#{txn_id}&type=#{@email_verification_type}"

    with true <- @email_verification_type == type,
         {:ok, %{email: email, user_id: user_id}} <- get_user_info_from_cache(txn_id),
         %User{} = user <- User.get_by_id(user_id),
         true <- user.email == email do
      User.update(user, %{is_email_verified: true})

      {:ok, %{message: "Your email has been verified"}}
    else
      false -> {:error, :bad_request, %{message: "Wrong info sent"}}
      nil -> {:error, :not_found, %{message: "User not found"}}
      {:error, code, message} -> {:error, code, message}
    end
  end

  defp create_txn_id_for_email_confirmation(user) do
    key = "txn_id=#{UUID.generate_uuid()}&type=#{@email_verification_type}"
    value = "email=#{user.email}&id=#{user.id}"
    CacheService.set(key, value)

    {:ok, key}
  end

  defp get_user_info_from_cache(txn_id) do
    key = "txn_id=#{txn_id}&type=#{@email_verification_type}"
    {:ok, value} = CacheService.get(key)

    case value do
      nil ->
        {:error, :bad_request, %{message: "Wrong verification link"}}

      _ ->
        key_arr = String.split(value, "&")

        user_id =
          key_arr
          |> Enum.at(1)
          |> String.split("=")
          |> Enum.at(1)

        email =
          key_arr
          |> Enum.at(0)
          |> String.split("=")
          |> Enum.at(1)

        {:ok, %{email: email, user_id: user_id}}
    end
  end
end
