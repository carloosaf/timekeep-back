defmodule TimekeepWeb.CounterController do
  use TimekeepWeb, :controller

  alias Timekeep.Counters
  alias Timekeep.Counters.Counter
  alias TimekeepWeb.Dtos.CreateCounter
  alias TimekeepWeb.Dtos.UpdateCounter
  import Timekeep.Utils

  action_fallback TimekeepWeb.FallbackController

  def index(conn, _params) do
    counters = Counters.list_counters()
    render(conn, :index, counters: counters)
  end

  def create(conn, %{"counter" => counter_params}) do
    counter_params = Map.put(counter_params, "owner", conn.assigns.current_user)

    with :ok <- CreateCounter.changeset(%CreateCounter{}, counter_params) |> validate_dto(),
         {:ok, %Counter{} = counter} <- Counters.create_counter(counter_params) do
      conn
      |> put_status(:created)
      |> render(:show, counter: counter)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, counter} <- Counters.get_counter(id) do
      render(conn, :show, counter: counter)
    end
  end

  def update(conn, %{"id" => id, "counter" => counter_params}) do
    with :ok <- UpdateCounter.changeset(%UpdateCounter{}, counter_params) |> validate_dto(),
         {:ok, counter} <- Counters.get_counter(id),
         {:ok, %Counter{} = counter} <- Counters.update_counter(counter, counter_params) do
      render(conn, :show, counter: counter)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, counter} <- Counters.get_counter(id),
         {:ok, %Counter{}} <- Counters.delete_counter(counter) do
      send_resp(conn, :no_content, "")
    end
  end

  def tracker(conn, %{"counter_id" => id}) do
    month = Map.get(conn.query_params, "month")
    year = Map.get(conn.query_params, "year")

    with {:ok, counter} <- Counters.get_counter(id) do
      render(conn, :tracker, tracker: Counters.get_tracker(counter, month, year))
    end
  end
end
