defmodule SecretKeeper do
  @moduledoc """
  SecretKeeper keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def migration do
    quote do
      use Ecto.Migration

      import SecretKeeper.ModelHelpers.SoftDelete.Migration
      import SecretKeeper.ModelHelpers.UUID.Migration
    end
  end

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Query
      import Ecto.Changeset
      import SecretKeeper.ModelHelpers.UUID.Schema
      import SecretKeeper.ModelHelpers.SoftDelete.Schema
      import Logger
      alias SecretKeeper.Repo
      alias SecretKeeper.Schemas.V1, as: Schemas
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
