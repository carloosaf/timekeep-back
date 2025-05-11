defmodule Timekeep.CountersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timekeep.Counters` context.
  """

  @doc """
  Generate a counter.
  """
  def counter_fixture(attrs \\ %{}) do
    {:ok, counter} =
      attrs
      |> Enum.into(%{
        name: "some name",
        period: :daily,
        time_objective: 42
      })
      |> Timekeep.Counters.create_counter()

    counter
  end
end
