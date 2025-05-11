defmodule TimekeepWeb.Dtos.CreateSession do
  use Ecto.Schema
  import Ecto.Changeset
  import Timekeep.Utils

  @primary_key false
  embedded_schema do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:start_time, :end_time])
    |> validate_end_after_start()
  end
end
