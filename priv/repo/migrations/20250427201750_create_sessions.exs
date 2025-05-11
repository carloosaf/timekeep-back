defmodule Timekeep.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :start_time, :naive_datetime
      add :end_time, :naive_datetime
      add :time_spent, :integer
      add :counter_id, references(:counters, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:sessions, [:counter_id])
  end
end
