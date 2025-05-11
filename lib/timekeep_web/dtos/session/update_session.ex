defmodule TimekeepWeb.Dtos.UpdateSession do
  use Ecto.Schema
  import Ecto.Changeset
  import Timekeep.Utils

  @primary_key false
  embedded_schema do
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
  end

  def changeset(struct, attrs) do
    changeset =
      struct
      |> cast(attrs, [:start_time, :end_time])

    if attrs[:start_time] != nil && attrs[:end_time] != nil,
      do: validate_end_after_start(struct),
      else: changeset
  end
end
