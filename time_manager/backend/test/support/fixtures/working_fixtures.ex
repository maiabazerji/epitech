defmodule TimeManager.WorkingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Working` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-08 08:50:00],
        start: ~N[2024-10-08 08:50:00]
      })
      |> TimeManager.Working.create_working_time()

    working_time
  end
end
