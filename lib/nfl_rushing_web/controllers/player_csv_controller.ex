defmodule NflRushingWeb.PlayerCsvController do
  use NflRushingWeb, :controller

  alias NflRushing.Stats

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
    chunk(conn, Stats.csv_headers() <> "\n")

    Stats.stream_players_to_csv(sort_by, sort_order, player_name, fn stream ->
      for player <- stream do
        {:ok, parsed_player} = Stats.player_struct_to_csv(player)
        conn |> chunk(parsed_player <> "\n")
      end
    end)

    conn
  end
end
