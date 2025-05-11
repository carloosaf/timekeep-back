defmodule Timekeep.Repo.Migrations.CreateCounters do
  use Ecto.Migration

  def change do
    create table(:counters) do
      add :name, :string
      add :period, :string
      add :time_objective, :integer
      add :current_time_spent, :integer
      add :owner, :string

      timestamps(type: :utc_datetime)
    end
  end
end
