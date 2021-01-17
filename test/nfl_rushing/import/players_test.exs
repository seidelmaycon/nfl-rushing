defmodule NflRushing.Import.PlayersTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Import.Players

  describe "insert_players_from_json_file/1" do
    test "with a valid json file" do
      assert {:ok, 2} = Players.insert_players_from_json_file("test/fixtures/player_stats.json")
    end
  end
end
