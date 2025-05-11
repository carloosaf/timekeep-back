defmodule TimekeepWeb.Dtos.CreateCounter do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :period, Ecto.Enum, values: [:daily, :weekly, :monthly, :yearly]
    field :time_objective, :integer
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:name, :period, :time_objective])
    |> validate_required([:name, :period, :time_objective])
    |> validate_length(:name, min: 1, max: 50)
    |> validate_number(:time_objective, greater_than: 0)
  end
end
