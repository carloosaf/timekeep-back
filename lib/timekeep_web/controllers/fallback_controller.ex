defmodule TimekeepWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TimekeepWeb, :controller
  require Logger

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: TimekeepWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: TimekeepWeb.ErrorJSON)
    |> render("error.json", %{code: "NOT_FOUND", message: "Entity not found"})
  end

  def call(conn, {:error, :not_owner}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: TimekeepWeb.ErrorJSON)
    # Return not found to avoid leaking information
    |> render("error.json", %{code: "NOT_FOUND", message: "Entity not found"})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: TimekeepWeb.ErrorJSON)
    |> render("error.json", %{code: "UNAUTHORIZED", message: "Unauthorized"})
  end

  def call(conn, {:error, :session_already_started}) do
    conn
    |> put_status(:conflict)
    |> put_view(json: TimekeepWeb.ErrorJSON)
    |> render("error.json", %{
      code: "SESSION_ALREADY_STARTED",
      message: "There is another session started"
    })
  end

  def call(conn, error) do
    Logger.error(inspect(error))

    conn
    |> put_status(:internal_server_error)
    |> put_view(json: TimekeepWeb.ErrorJSON)
    |> render("error.json", %{code: "INTERNAL_SERVER_ERROR", message: "Internal Server Error"})
  end
end
