defmodule TimekeepWeb.SessionController do
  use TimekeepWeb, :controller

  alias TimekeepWeb.Dtos.UpdateSession
  alias TimekeepWeb.Dtos.CreateSession
  alias Timekeep.Counters
  alias Timekeep.Counters.Counter
  alias Timekeep.Counters.Session
  import Timekeep.Utils

  action_fallback TimekeepWeb.FallbackController

  defp user_owns_counter(%Counter{} = counter, conn) do
    user = conn.assigns.current_user

    if counter.owner == user do
      :ok
    else
      {:error, :not_owner}
    end
  end

  def index(conn, %{"counter_id" => id}) do
    with {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         sessions <- Counters.list_sessions(counter) do
      render(conn, :index, sessions: sessions)
    end
  end

  def create(conn, %{"counter_id" => id, "session" => session_params}) do
    with :ok <- CreateSession.changeset(%CreateSession{}, session_params) |> validate_dto(),
         {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.create_session(counter, session_params) do
      render(conn, :show, session: session)
    end
  end

  def show(conn, %{"counter_id" => id, "id" => id_session}) do
    with {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.get_session(id_session) do
      render(conn, :show, session: session)
    end
  end

  def update(conn, %{"counter_id" => id, "id" => id_session, "session" => session_params}) do
    with :ok <- UpdateSession.changeset(%UpdateSession{}, session_params) |> validate_dto(),
         {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.get_session(id_session),
         {:ok, session} <- Counters.update_session(session, session_params) do
      render(conn, :show, session: session)
    end
  end

  def delete(conn, %{"counter_id" => id, "id" => id_session}) do
    with {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.get_session(id_session),
         {:ok, %Session{}} <- Counters.delete_session(session) do
      send_resp(conn, :no_content, "")
    end
  end

  def start(conn, %{"counter_id" => id}) do
    with {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.start_session(counter) do
      render(conn, :show, session: session)
    end
  end

  def stop(conn, %{"counter_id" => id}) do
    with {:ok, counter} <- Counters.get_counter(id),
         :ok <- user_owns_counter(counter, conn),
         {:ok, session} <- Counters.end_session(counter) do
      render(conn, :show, session: session)
    end
  end
end
