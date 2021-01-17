defmodule NflRushing.Import.Players.Handler do
  @moduledoc """
  Persist a parsed players array in the database
  """

  alias NflRushing.Repo
  alias NflRushing.Stats.Player

  @batch_size 1000

  def insert_all(players) when is_list(players) do
    players
    |> Enum.chunk_every(@batch_size)
    |> Enum.map(&Repo.insert_all(Player, &1))
    |> total_records_inserted()
  end

  defp total_records_inserted(chunked_records) do
    {:ok,
     chunked_records
     |> Enum.map(fn {count, _} -> count end)
     |> Enum.sum()}
  end
end
