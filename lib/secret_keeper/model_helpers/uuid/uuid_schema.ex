defmodule SecretKeeper.ModelHelpers.UUID.Schema do
  @moduledoc """
  Contains schema macros to add uuid fields to a schema
  """

  @doc """
  Adds the uuid column to a schema
      defmodule User do
        use Ecto.Schema
        import SecretKeeper.ModelHelpers.UUID.Schema
        schema "users" do
          field :email,           :string
          uuid_schema()
        end
      end
  """
  defmacro uuid_schema do
    quote do
      field(:uuid, :binary_id, read_after_writes: true)
    end
  end

  @doc """
  Generates and return uuid
  """
  def generate_uuid() do
    Ecto.UUID.generate()
  end

  @doc """
  Converts UUID in binary to string
  """
  def convert_uuid_to_string(uuid) do
    with {:ok, stringified_uuid} <- Ecto.UUID.load(uuid) do
      stringified_uuid
    else
      _ ->
        {:error, :bad_request, %{message: "invalid uuid"}}
    end
  end
end
