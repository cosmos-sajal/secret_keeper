defmodule SecretKeeper.Repo.Migrations.CreateUsers do
  use SecretKeeper, :migration

  def change do
    create table(:users) do
      add(:name, :string, null: false)
      add(:email, :string, null: true)
      add(:is_email_verified, :boolean, default: false)
      add(:password_hash, :string, null: true)

      soft_delete_columns()
      uuid_column()
      timestamps(type: :utc_datetime)
    end
  end
end
