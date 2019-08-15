defmodule SecretKeeper.Auth.AuthAccessPipeline do
  @moduledoc false

  use Guardian.Plug.Pipeline, otp_app: :secret_keeper

  plug(Guardian.Plug.VerifyHeader, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
  plug(SecretKeeper.Auth.EnsureEmailVerification)
end
