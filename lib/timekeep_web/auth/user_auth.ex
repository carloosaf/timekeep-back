defmodule TimekeepWeb.UserAuth do
  alias TimekeepWeb.Auth.Token
  import Plug.Conn

  def fetch_current_user(conn, _opts) do
    conn =
      with {:ok, claims} <- validate_user_token(conn) do
        user = claims["sub"]
        assign(conn, :current_user, user)
      else
        _ -> assign(conn, :current_user, nil)
      end

    conn
  end

  defp validate_user_token(conn) do
    with [auth_header | _] <- get_req_header(conn, "authorization"),
         ["Bearer", token] <- String.split(auth_header, " ", parts: 2),
         true <- token != nil do
      Token.verify_and_validate(token)
    else
      _ -> {:error, :no_token}
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{code: "UNAUTHORIZED", message: "The user is not authenticated"})
      |> halt()
    end
  end

  def require_not_autenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> put_status(:unauthorized)
      |> Phoenix.Controller.json(%{
        code: "UNAUTHORIZED",
        message: "The user is already authenticated"
      })
      |> halt()
    else
      conn
    end
  end
end
