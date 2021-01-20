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

  describe "stream_players/1" do
    test "convert a list of players by streams" do
      [player_1, player_2] = insert_list(2, :player)

      Stats.stream_players(~w(name)a, "name", "asc", "", fn players ->
        assert players |> Enum.to_list() |> Enum.map(&Map.get(&1, :name)) == [
                 player_1.name,
                 player_2.name
               ]
      end)
    end

    test "with invalid sort_by" do
      assert {:error, :invalid_params} ==
               Stats.stream_players(~w(name)a, nil, "asc", "", fn _ -> nil end)
    end

    test "with invalid sort_order" do
      assert {:error, :invalid_params} ==
               Stats.stream_players(~w(name)a, "name", "invalid", "", fn _ -> nil end)
    end
  end
end
