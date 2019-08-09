defmodule SecretKeeper.ModelHelpers.UUID.Migration do
  @moduledoc """
  Contains functions to add uuid columns to a table during migrations
  """

  use Ecto.Migration

  @doc """
  Adds uuid column to a table.
      defmodule MyApp.Repo.Migrations.CreateUser do
        use Ecto.Migration
        import SecretKeeper.ModelHelpers.UUID.Migration
        def change do
          create table(:users) do
            add :email, :string
            add :password, :string
            timestamps()

            uuid_column()
          end
        end
      end
  """
  def uuid_column() do
    add(:uuid, :uuid, default: fragment("uuid_generate_v4()"))
  end

  @doc """
  Adds an index on uuid column of the given table

  ## Parameters
    - table_name: the table for which the index has to be created
  """
  def create_index_on_uuid(table_name) do
    create(index(table_name, [:uuid]))
  end
end
