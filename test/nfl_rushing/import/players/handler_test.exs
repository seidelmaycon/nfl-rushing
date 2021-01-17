defmodule NflRushing.Import.Players.HandlerTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Import.Players.Handler

  describe "insert_all/1" do
    test "with a valid array of players" do
      parsed_players = [
        %{
          first_down_percentage: 0.0,
          first_downs_total: 0,
          longest_rush_yards: 9.0,
          name: "Shaun Hill",
          position: "QB",
          rushing_attemps_game_average: 1.7,
          rushing_attemps_total: 5,
          rushing_fumbles: 0,
          rushing_over_forty_yards_count: 0,
          rushing_over_twenty_yards_count: 0,
          rushing_touchdown_total: 0,
          rushing_yards_attempt_average: 1.0,
          rushing_yards_game_average: 1.7,
          rushing_yards_total: 5.0,
          team: "MIN"
        },
        %{
          first_down_percentage: 0.0,
          first_downs_total: 0,
          longest_rush_yards: 7.0,
          name: "Joe Banyard",
          position: "RB",
          rushing_attemps_game_average: 2.0,
          rushing_attemps_total: 2,
          rushing_fumbles: 0,
          rushing_over_forty_yards_count: 0,
          rushing_over_twenty_yards_count: 0,
          rushing_touchdown_total: 0,
          rushing_yards_attempt_average: 3.5,
          rushing_yards_game_average: 7.0,
          rushing_yards_total: 7.0,
          team: "JAX"
        }
      ]

      assert {:ok, 2} = Handler.insert_all(parsed_players)
    end
  end
end
