defmodule NflRushingWeb.PlayerCsvControllerTest do
  use NflRushingWeb.ConnCase, async: true

  describe "GET export" do
    test "reutrns ok with valid params", %{conn: conn} do
      insert(:player)

      player_stats_path =
        Routes.player_csv_path(conn, :export, player_name: "", sort_by: "name", sort_order: "asc")

      conn =
        conn
        |> get(player_stats_path)

      assert conn.status == 200
      assert conn.resp_body == ""
    end

    test "redirects back with invalid params", %{conn: conn} do
      player_stats_path =
        Routes.player_csv_path(conn, :export, sort_by: "name", sort_order: "asc")

      assert conn
             |> get(player_stats_path)
             |> response(:found)
             |> String.contains?("redirected")
    end
  end
end
