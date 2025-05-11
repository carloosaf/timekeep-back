defmodule Timekeep.Counters.Session do
  use Ecto.Schema
  import Ecto.Changeset
  import Timekeep.Utils

  schema "sessions" do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :time_spent, :integer
    belongs_to :counter, Timekeep.Counters.Counter

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:start_time, :end_time])
    |> validate_end_after_start()
    |> compute_time_spent()
  end

  def start_session_changeset(session, attrs) do
    session
    |> cast(attrs, [:start_time])
    |> validate_required([:start_time])
  end

  def end_session_changeset(session, attrs) do
    session
    |> cast(attrs, [:end_time])
    |> validate_required([:end_time])
    |> validate_end_after_start()
    |> compute_time_spent()
  end

  defp compute_time_spent(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    changeset
    |> put_change(:time_spent, NaiveDateTime.diff(end_time, start_time, :second))
  end
end
