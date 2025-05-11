defmodule Timekeep.Counters.Counter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "counters" do
    field :name, :string
    field :period, Ecto.Enum, values: [:daily, :weekly, :monthly, :yearly]
    field :time_objective, :integer
    field :current_time_spent, :integer, default: 0
    field :owner, :string
    has_many :sessions, Timekeep.Counters.Session

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(counter, attrs) do
    counter
    |> cast(attrs, [:name, :period, :time_objective, :owner])
    |> validate_required([:name, :period, :time_objective, :owner])
  end
end
