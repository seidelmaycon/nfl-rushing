defmodule Mix.Tasks.ImportPlayersTest do
  use NflRushing.DataCase, async: true

  alias Mix.Tasks.ImportPlayers
  alias NflRushing.Repo
  alias NflRushing.Stats.Player

  describe "run/1" do
    test "insert players" do
      ImportPlayers.run("test/fixtures/player_stats.json")

      assert Repo.aggregate(Player, :count) == 2
    end
  end
end
