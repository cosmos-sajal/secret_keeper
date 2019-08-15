defmodule SecretKeeper.Auth.AuthErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    status_code = get_status_code(type)

    body =
      type
      |> get_body(reason)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status_code, body)
  end

  defp get_status_code(type) do
    case type do
      :forbidden ->
        403

      :unverified_email ->
        403

      _ ->
        401
    end
  end

  defp get_body(type, reason) do
    error_struct = %{error: to_string(type)}
    %{error: error_message} = error_struct

    cond do
      is_binary(reason) ->
        %{error: reason}

      is_atom(reason) ->
        %{error: to_string(reason)}

      true ->
        %{error: to_string(type)}
    end
  end
end
