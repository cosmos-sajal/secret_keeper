defmodule SecretKeeper.Services.V1.CryptographyModule.CryptographyService do
  @moduledoc false

  @encryption_algo :aes_ecb

  def encrypt(plaintext, key) do
    @encryption_algo
    |> :crypto.block_encrypt(:crypto.hash(:sha256, key), plaintext)
    |> Base.encode16()
  end

  def decrypt(ciphertext, key) do
    :crypto.block_decrypt(
      @encryption_algo,
      :crypto.hash(:sha256, key),
      Base.decode16!(ciphertext)
    )
  end
end
