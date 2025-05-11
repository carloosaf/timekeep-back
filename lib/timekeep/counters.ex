defmodule Timekeep.Counters do
  @moduledoc """
  The Counters context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Changeset
  alias Plug.Session
  alias Timekeep.Counters.Session
  alias Timekeep.Repo

  alias Timekeep.Counters.Counter

  @doc """
  Returns the list of counters.

  ## Examples

      iex> list_counters()
      [%Counter{}, ...]

  """
  def list_counters do
    Repo.all(Counter)
  end

  @doc """
  Gets a single counter.

  ## Examples

      iex> get_counter(123)
      %Counter{}

      iex> get_counter(456)
      {:error, :not_found}

  """
  def get_counter(id) do
    counter = Repo.get(Counter, id)

    case counter do
      nil -> {:error, :not_found}
      _ -> {:ok, counter}
    end
  end

  @doc """
  Creates a counter.

  ## Examples

      iex> create_counter(%{field: value})
      {:ok, %Counter{}}

      iex> create_counter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_counter(attrs \\ %{}) do
    %Counter{}
    |> Counter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a counter.

  ## Examples

      iex> update_counter(counter, %{field: new_value})
      {:ok, %Counter{}}

      iex> update_counter(counter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_counter(%Counter{} = counter, attrs) do
    counter
    |> Counter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a counter.

  ## Examples

      iex> delete_counter(counter)
      {:ok, %Counter{}}

      iex> delete_counter(counter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_counter(%Counter{} = counter) do
    Repo.delete(counter)
  end

  @doc """
  Returns the list of sessions for a counter.

  ## Examples

      iex> list_sessions(counter)
      [%Session{}, ...]
  """
  def list_sessions(%Counter{} = counter) do
    counter
    |> Ecto.assoc(:sessions)
    |> Repo.all()
  end

  @doc """
  Creates a session for a counter.

  ## Examples

      iex> create_session(counter, valid_attrs)
      {:ok, %Session{}}

      iex> create_session(counter, invalid_attrs)
      {:error, %Ecto.Changeset{}}
  """
  def create_session(%Counter{} = counter, attrs) do
    %Session{}
    |> Session.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:counter, counter)
    |> Repo.insert()
  end

  @doc """
  Gets a session by its id.

  ## Examples

      iex> get_session(id)
      %Session{}

      iex> get_session(id)
      {:error, :not_found}
  """
  def get_session(id) do
    session = Repo.get(Session, id)

    case session do
      nil -> {:error, :not_found}
      _ -> {:ok, session}
    end
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, valid_attrs)
      {:ok, %Session{}}

      iex> update_session(session, invalid_attrs)
      {:error, %Ecto.Changeset{}}
  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}
  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  defp find_active_session(%Counter{} = counter) do
    counter
    |> Ecto.assoc(:sessions)
    |> Repo.all()
    |> Enum.find(fn session -> session.end_time == nil end)
  end

  @doc """
  Starts a session for a counter.

  ## Examples

    iex> start_session(counter)
    {:ok, %Session{}}

    iex> start_session(counter)
    {:error, :already_started}
  """
  def start_session(%Counter{} = counter) do
    case find_active_session(counter) do
      nil ->
        %Session{}
        |> Session.start_session_changeset(%{start_time: DateTime.utc_now()})
        |> Changeset.put_assoc(:counter, counter)
        |> Repo.insert()

      _session ->
        {:error, :session_already_started}
    end
  end

  @doc """
  Ends a session for a counter.

  ## Examples

      iex> end_session(counter)
      {:ok, %Session{}}

      iex> end_session(counter)
      {:error, :not_found}
  """
  def end_session(%Counter{} = counter) do
    case find_active_session(counter) do
      nil ->
        {:error, :not_found}

      session ->
        session
        |> Session.end_session_changeset(%{end_time: DateTime.utc_now()})
        |> Repo.update()
    end
  end

  defp get_sessions_by_month(counter, month, year) do
    counter
    |> Ecto.assoc(:sessions)
    |> where([s], fragment("EXTRACT(MONTH FROM ?)", s.start_time) == ^month)
    |> where([s], fragment("EXTRACT(YEAR FROM ?)", s.start_time) == ^year)
    |> Repo.all()
  end

  @doc """
  Returns a habit tracker for a counter. The tracker
  is a list of days with the number of sessions for each day.

  ## Examples

      iex> get_tracker(counter)
      [{1, 2}, {2, 0}, {3, 1}, ...]
  """
  def get_tracker(
        counter,
        month \\ nil,
        year \\ nil
      ) do
    current_date = DateTime.utc_now()
    month = month || current_date.month
    year = year || current_date.year

    case {month, year} do
      {_month, _year} when month > current_date.month or year > current_date.year ->
        {:error, :future_date}

      _ ->
        sessions = get_sessions_by_month(counter, month, year)
        days_in_month = Calendar.ISO.days_in_month(year, month)

        sessions_by_day =
          sessions
          |> Enum.group_by(fn session -> session.start_time.day end)

        Enum.map(1..days_in_month, fn day ->
          session_count = sessions_by_day |> Map.get(day, []) |> length()
          %{day: day, count: session_count}
        end)
    end
  end
end
