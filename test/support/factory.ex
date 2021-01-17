defmodule NflRushing.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: NflRushing.Repo

  alias NflRushing.Stats.Player

  def player_factory do
    %Player{
      name: sequence(:name, &"player n-#{&1}"),
      team: sequence(:team, &"team n-#{&1}"),
      position: sequence(:position, &"p-#{&1}"),
      rushing_attemps_game_average: 0.5,
      rushing_attemps_total: 8,
      rushing_yards_total: 21,
      rushing_yards_attempt_average: 2.6,
      rushing_yards_game_average: 1.3,
      rushing_touchdown_total: 1,
      longest_rush_yards: 15,
      longest_rush_with_touchdown: false,
      first_downs_total: 2,
      first_down_percentage: 25,
      rushing_over_twenty_yards_count: 0,
      rushing_over_forty_yards_count: 0,
      rushing_fumbles: 1
    }
  end
end
