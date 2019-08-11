defmodule SecretKeeper.Services.V1.AuthModule.TOTPService do
  @moduledoc false

  @key_length 16

  def create_key_for_totp() do
    @key_length |> :crypto.strong_rand_bytes() |> Base.encode32() |> binary_part(0, @key_length)
  end

  def check_token(totp_key, token) do
    totp_key |> :pot.totp(timestamp: :os.timestamp()) == token
  end
end
