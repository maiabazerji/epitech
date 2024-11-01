defmodule TimeManager.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManager.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManager.Teams.create_team()

    team
  end
end
