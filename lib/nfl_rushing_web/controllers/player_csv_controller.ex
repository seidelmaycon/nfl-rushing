defmodule NflRushingWeb.PlayerCsvController do
  use NflRushingWeb, :controller

  alias NflRushing.Stats

  @csv_columns ~w(name team position rushing_attemps_game_average rushing_attemps_total rushing_yards_total
                  rushing_yards_attempt_average rushing_yards_game_average rushing_touchdown_total longest_rush_yards
                  longest_rush_with_touchdown first_downs_total first_down_percentage rushing_over_twenty_yards_count
                  rushing_over_forty_yards_count rushing_fumbles)a

  def export(conn, %{
        "sort_by" => sort_by,
        "sort_order" => sort_order,
        "player_name" => player_name
      }) do
    conn
    |> put_resp_header("content-disposition", "attachment; filename=players_stats.csv")
    |> put_resp_content_type("text/csv")
    |> send_chunked(:ok)
    |> fetch_and_chunk_players(sort_by, sort_order, player_name)
  end

  def export(conn, _) do
    conn
    |> put_flash(:error, :invalid_params)
    |> redirect(to: Routes.player_stats_index_path(conn, :index))
  end

  defp fetch_and_chunk_players(conn, sort_by, sort_order, player_name) do
    conn |> chunk(Enum.join(@csv_columns, ",") <> "\n")

    Stats.stream_players(@csv_columns, sort_by, sort_order, player_name, fn stream ->
      for player <- stream do
        parsed_player = player_struct_to_csv(player, @csv_columns) <> "\n"
        conn |> chunk(parsed_player)
      end
    end)

    conn
  end

  def player_struct_to_csv(player, columns) do
    columns
    |> Enum.map(&Map.get(player, &1))
    |> Enum.join(",")
  end
end
