defmodule Timekeep.Utils do
  import Ecto.Changeset

  @doc """
  Validates if the end date of the session
  is after the start date
  """
  def validate_end_after_start(changeset) do
    start_time = get_field(changeset, :start_time)
    end_time = get_field(changeset, :end_time)

    if NaiveDateTime.after?(end_time, start_time) do
      changeset
    else
      add_error(changeset, :end_time, "must be after start time")
    end
  end

  @doc """
    Checks if the changeset is valid
  """
  def validate_dto(dto) do
    if dto.valid? do
      :ok
    else
      {:error, dto}
    end
  end
end
