defmodule NflRushing.StatsTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats

  describe "list_players/1" do
    test "return players sorted by rushing_yards_total" do
      player_1 = insert(:player, rushing_yards_total: 10)
      player_2 = insert(:player, rushing_yards_total: 5)
      player_3 = insert(:player, rushing_yards_total: 1)

      criteria = [
        paginate: %{page: 1, per_page: 15},
        sort: %{sort_by: "rushing_yards_total", sort_order: "asc"},
        filter: %{player_name: ""}
      ]

      assert [player_3, player_2, player_1] == Stats.list_players(criteria)
    end

    test "return players paginated" do
      insert_list(5, :player)

      criteria = [
        paginate: %{page: 1, per_page: 2},
        sort: %{sort_by: "id", sort_order: "asc"},
        filter: %{player_name: ""}
      ]

      assert Stats.list_players(criteria) |> Enum.count() == 2
    end

    test "return players filtred by name" do
      [player_1 | _] = insert_list(5, :player)

      criteria = [
        paginate: %{page: 1, per_page: 15},
        sort: %{sort_by: "id", sort_order: "asc"},
        filter: %{player_name: player_1.name}
      ]

      assert [player_1] == Stats.list_players(criteria)
    end
  end

  describe "stream_players_to_csv/4" do
    test "convert a list of players by streams to a csv format" do
      [player_1, player_2] = insert_list(2, :player) |> Enum.sort(&(&1.name <= &2.name))

      Stats.stream_players_to_csv("name", "asc", "", fn players ->
        assert players |> Enum.to_list() |> Enum.map(&Map.get(&1, :name)) == [
                 player_1.name,
                 player_2.name
               ]
      end)
    end

    test "with invalid sort_by" do
      assert {:error, :invalid_params} ==
               Stats.stream_players_to_csv(nil, "asc", "", fn _ -> nil end)
    end

    test "with invalid sort_order" do
      assert {:error, :invalid_params} ==
               Stats.stream_players_to_csv("name", "invalid", "", fn _ -> nil end)
    end
  end

  describe "player_struct_to_csv/1" do
    test "with a valid player struct" do
      player_1 = build(:player, name: "john", team: "NE", position: "QB")

      expected = {:ok, "john,NE,QB,0.5,8,21,2.6,1.3,1,15,false,2,25,0,0,1"}

      assert Stats.player_struct_to_csv(player_1) == expected
    end

    test "with invalid params" do
      assert {:error, :invalid_params} == Stats.player_struct_to_csv(nil)
    end
  end

  describe "csv_headers/0" do
    test "returns players columns" do
      assert Stats.csv_headers() ==
               "name,team,position,rushing_attemps_game_average,rushing_attemps_total," <>
                 "rushing_yards_total,rushing_yards_attempt_average,rushing_yards_game_average," <>
                 "rushing_touchdown_total,longest_rush_yards,longest_rush_with_touchdown," <>
                 "first_downs_total,first_down_percentage,rushing_over_twenty_yards_count," <>
                 "rushing_over_forty_yards_count,rushing_fumbles"
    end
  end
end
