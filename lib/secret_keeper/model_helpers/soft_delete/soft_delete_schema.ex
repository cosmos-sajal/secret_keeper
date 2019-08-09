defmodule SecretKeeper.ModelHelpers.SoftDelete.Schema do
  @moduledoc """
  Contains schema macros to add soft delete fields to a schema
  """
  import Ecto.Query

  alias SecretKeeper.Repo

  @doc """
  Adds the deleted_at column to a schema
      defmodule User do
        use Ecto.Schema
        import SecretKeeper.ModelHelpers.SoftDelete.Schema
        schema "users" do
          field :email,           :string
          soft_delete_schema()
        end
      end
  """
  defmacro soft_delete_schema do
    quote do
      field(:is_deleted, :boolean, default: false)
      field(:deleted_at, :utc_datetime)
    end
  end

  @doc """
  Adds where clause to the query for non soft deleted rows

  ## Parameters
    - query: ecto query
  """
  def with_non_soft_delete(query) do
    query
    |> where([t], t.is_deleted == false)
  end

  @doc """
  Marks a row deleted when passed its specific struct pertaining to any table

  ## Parameters
    - struct: Entity for DB
  """
  def delete_entity(struct) do
    struct
    |> Ecto.Changeset.change(%{
      is_deleted: true,
      deleted_at: DateTime.truncate(DateTime.utc_now(), :second)
    })
    |> Repo.update()
  end
end
