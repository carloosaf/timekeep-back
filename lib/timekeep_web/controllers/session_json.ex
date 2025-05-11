defmodule TimekeepWeb.SessionJSON do
  alias Timekeep.Counters.Session

  @doc """
  Renders a list of sessions.
  """
  def index(%{sessions: sessions}) do
    %{data: for(session <- sessions, do: data(session))}
  end

  @doc """
  Renders a single session.
  """
  def show(%{session: session}) do
    %{data: data(session)}
  end

  defp data(%Session{} = session) do
    %{
      id: session.id,
      start_time: session.start_time,
      end_time: session.end_time,
      time_spent: session.time_spent
    }
  end
end
