defmodule NflRushingWeb.PlayerStatsLive.IndexTest do
  use NflRushingWeb.ConnCase

  import Phoenix.LiveViewTest
  import Ecto.Query

  alias NflRushing.Repo
  alias NflRushing.Stats.Player

  describe "PlayerStats.Index" do
    test "lists players", %{conn: conn} do
      insert_list(25, :player)

      players = from(Player, order_by: :id) |> Repo.all()

      {:ok, _view, html} = live(conn, Routes.player_stats_index_path(conn, :index))

      assert html =~ Enum.at(players, 0) |> Map.get(:name)
      assert html =~ Enum.at(players, 14) |> Map.get(:name)
      refute html =~ Enum.at(players, 15) |> Map.get(:name)
    end

    test "renders more players on infinit scroll hook", %{conn: conn} do
      insert_list(60, :player)

      players = from(Player, order_by: :id) |> Repo.all()

      {:ok, view, _html} = live(conn, Routes.player_stats_index_path(conn, :index))

      html = render_hook(view, "load-more", %{page: 2, per_page: 15})

      assert html =~ Enum.at(players, 0) |> Map.get(:name)
      assert html =~ Enum.at(players, 20) |> Map.get(:name)
      refute html =~ Enum.at(players, 55) |> Map.get(:name)
    end

    test "toggles the rushing_touchdown_total sort option", %{conn: conn} do
      player_1 = insert(:player, rushing_touchdown_total: 3)
      player_2 = insert(:player, rushing_touchdown_total: 2)
      player_3 = insert(:player, rushing_touchdown_total: 1)

      {:ok, _view, html} =
        live(
          conn,
          Routes.player_stats_index_path(
            conn,
            :index,
            sort_by: :rushing_touchdown_total,
            sort_order: "desc",
            page: 1,
            per_page: 15
          )
        )

      [_, _, first_elem, second_elem, third_elem] = String.split(html, "tr id=")

      assert first_elem =~ player_1.name
      assert second_elem =~ player_2.name
      assert third_elem =~ player_3.name
    end

    test "filters by player name when a player-name-search event is called ", %{conn: conn} do
      player_1 = insert(:player, name: "Joe Montana")
      player_2 = insert(:player, name: "Jerry Rice")
      player_3 = insert(:player, name: "Lawrence Taylor")
      {:ok, view, _html} = live(conn, Routes.player_stats_index_path(conn, :index))

      html =
        view
        |> render_change("player-name-search", %{"player" => %{"name" => "jerry"}})

      assert html =~ player_2.name
      refute html =~ player_1.name
      refute html =~ player_3.name
    end

    test "when filters by player name returns no players ", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.player_stats_index_path(conn, :index))

      html =
        view
        |> render_change("player-name-search", %{"player" => %{"name" => "jerry"}})

      refute html =~ "No players matching"
    end
  end
end
