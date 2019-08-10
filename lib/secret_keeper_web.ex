defmodule SecretKeeperWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use SecretKeeperWeb, :controller
      use SecretKeeperWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: SecretKeeperWeb
      import Plug.Conn
      import SecretKeeperWeb.Router.Helpers
      import SecretKeeperWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/secret_keeper_web/templates",
        namespace: SecretKeeperWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import SecretKeeperWeb.Router.Helpers
      import SecretKeeperWeb.ErrorHelpers
      import SecretKeeperWeb.Gettext
    end
  end

  def params do
    quote do
      import Plug.Conn

      use Phoenix.Controller
      use SecretKeeper, :model

      def init(options), do: options

      defp error_messages(changeset) do
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", to_string(value))
          end)
        end)
      end

      def call(conn, key) do
        changeset = __MODULE__.changeset(struct(__MODULE__), conn.params)

        if changeset.valid? do
          validated_params = Map.merge(struct(__MODULE__), changeset.changes)

          conn |> assign(key, validated_params)
        else
          conn
          |> put_status(:bad_request)
          |> json(%{error: error_messages(changeset)})
          |> halt
        end
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import SecretKeeperWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
