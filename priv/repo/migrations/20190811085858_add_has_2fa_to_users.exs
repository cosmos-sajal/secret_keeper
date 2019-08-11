defmodule SecretKeeper.Repo.Migrations.AddHas2faToUsers do
  use SecretKeeper, :migration

  def change do
    alter table(:users) do
      add(:totp_key, :string, null: false)
    end
  end
end
