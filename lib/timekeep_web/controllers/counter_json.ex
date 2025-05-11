defmodule TimekeepWeb.CounterJSON do
  alias Timekeep.Counters.Counter

  @doc """
  Renders a list of counters.
  """
  def index(%{counters: counters}) do
    %{data: for(counter <- counters, do: data(counter))}
  end

  @doc """
  Renders a single counter.
  """
  def show(%{counter: counter}) do
    %{data: data(counter)}
  end

  def tracker(%{tracker: tracker}) do
    %{data: tracker}
  end

  defp data(%Counter{} = counter) do
    %{
      id: counter.id,
      name: counter.name,
      period: counter.period,
      time_objective: counter.time_objective,
      current_time_spent: counter.current_time_spent,
      owner: counter.owner
    }
  end
end
