defmodule SecretKeeperWeb.Api.V1.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SecretKeeperWeb, :controller

  def call(conn, %Ecto.Changeset{} = cs) do
    conn
    |> put_status(400)
    |> json(%{
      error: error_messages(cs)
    })
    |> halt
  end

  defp error_messages(changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      fn {msg, opts} ->
        Enum.reduce(
          opts,
          msg,
          fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", data_types_to_string(value))
          end
        )
      end
    )
  end

  defp data_types_to_string(value) when is_tuple(value) do
    Enum.join(Tuple.to_list(value), ":")
  end

  defp data_types_to_string(value) do
    to_string(value)
  end

  def call(conn, {:error, :conflict, message}) do
    conn
    |> put_status(:conflict)
    |> json(message)
  end

  def call(conn, {:error, :request_timeout, "Error genenerating_pdf"}) do
    conn
    |> put_status(:request_timeout)
  end

  def call(conn, {:error, :bad_request, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> render(TrafiWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :service_unavailable, message}) do
    conn
    |> put_status(:service_unavailable)
    |> json(message)
  end

  def call(conn, {:error, :not_found, message}) do
    conn
    |> put_status(:not_found)
    |> json(message)
  end

  def call(conn, {:error, :unauthorized, message}) do
    conn
    |> put_status(:unauthorized)
    |> json(message)
  end

  def call(conn, {:error, :bad_request, message}) do
    conn
    |> put_status(:bad_request)
    |> json(message)
  end

  def call(conn, {:error, :unauthorized, message, error_code}) do
    conn
    |> put_status(:unauthorized)
    |> json(message)
  end

  def call(conn, {:error, :not_acceptable, message}) do
    conn
    |> put_status(:not_acceptable)
    |> json(message)
  end

  def call(conn, {:error, :forbidden, message}) do
    conn
    |> put_status(:forbidden)
    |> json(message)
  end

  def call(conn, {:error, :internal_server_error, message}) do
    conn
    |> put_status(:internal_server_error)
    |> json(message)
  end

  def call(conn, {:error, :conflict, message}) do
    conn
    |> put_status(:conflict)
    |> json(message)
  end

  def call(conn, {:error, :internal_server_error}) do
    conn
    |> put_status(:internal_server_error)
  end

  def call(conn, {:error, %Postgrex.Error{}}) do
    conn
    |> put_status(:internal_server_error)
  end

  def call(conn, {:error, :gone, message}) do
    conn
    |> put_status(:gone)
    |> json(message)
  end

  def call(conn, {:error, :db_response_parsing_error}) do
    conn
    |> put_status(:internal_server_error)
  end

  def call(conn, {:error, :precondition_failed, message}) do
    conn
    |> put_status(:precondition_failed)
    |> json(message)
  end

  def call(conn, {:error, :link_expired, message}) do
    conn
    |> put_status(:forbidden)
    |> json(message)
  end

  def call(conn, {:error, :email_already_verified, message}) do
    conn
    |> put_status(:bad_request)
    |> json(message)
  end
end
