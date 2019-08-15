defmodule SecretKeeper.Auth.EnsureEmailVerification do
  @moduledoc """
  """
  import Plug.Conn

  alias Guardian.Plug.Pipeline
  alias SecretKeeper.Auth.Auth
  alias SecretKeeper.Schemas.V1.User

  @behaviour Plug

  @impl Plug
  @spec init(opts :: Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @impl Plug
  @spec call(conn :: Plug.Conn.t(), opts :: Keyword.t()) :: Plug.Conn.t()
  def call(conn, opts) do
    with user = %User{} <- Auth.get_user_from_jwt(conn) do
      case user.is_email_verified do
        true ->
          conn

        false ->
          conn
          |> get_error_conn(
            opts,
            :unverified_email,
            "Unverified Email"
          )
          |> halt()
      end
    else
      _ ->
        conn
        |> get_error_conn(opts, :not_found, "User not found")
        |> halt()
    end
  end

  def get_error_conn(conn, opts, status_type, message) do
    conn
    |> Pipeline.fetch_error_handler!(opts)
    |> apply(:auth_error, [
      conn,
      {status_type, message},
      opts
    ])
  end
end
