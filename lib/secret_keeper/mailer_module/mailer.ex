defmodule SecretKeeper.MailerModule.Mailer do
  @moduledoc """
  MailerModule
  """

  use Bamboo.Mailer, otp_app: :secret_keeper

  import Bamboo.Email

  @sender_email "sajal.4591@gmail.com"

  def send_email_verification_mail(reciever_email, link) do
    %{
      reciever_email: reciever_email,
      subject: "Verify your email!",
      text_body: "Email Verification",
      html_body: "<strong>Verification email!</strong> Click the link to verify: #{link}"
    }
    |> compose_mail()
    |> deliver_now()
  end

  defp compose_mail(
         %{
           reciever_email: reciever_email,
           html_body: html_body,
           text_body: text_body,
           subject: subject
         } = _params
       ) do
    new_email(
      to: reciever_email,
      from: @sender_email,
      subject: subject,
      html_body: html_body,
      text_body: text_body
    )
  end
end
