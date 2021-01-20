defmodule NflRushing.Stats do
  @moduledoc """
  Interface to manipulate Stats.Players data.
  """
  import Ecto.Query

  alias NflRushing.Stats.Player
  alias NflRushing.Repo

  @sort_fields ~w(id name rushing_yards_total rushing_touchdown_total longest_rush_yards)
  @sort_orders ~w(asc desc)

  def list_players(criteria) when is_list(criteria) do
    Player
    |> query(criteria)
    |> Repo.all()
  end

  def stream_players(columns, sort_by, sort_order, player_name, callback)
      when sort_by in @sort_fields and sort_order in @sort_orders do
    Repo.transaction(fn ->
      stream =
        from(p in Player, select: ^columns)
        |> query(
          sort: %{sort_by: sort_by, sort_order: sort_order},
          filter: %{player_name: player_name}
        )
        |> Repo.stream()

      callback.(stream)
    end)
  end

  def stream_players(_, _, _, _, _), do: {:error, :invalid_params}

  defp query(query, criteria) do
    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from p in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from p in query,
          order_by: [{^String.to_existing_atom(sort_order), ^String.to_existing_atom(sort_by)}]

      {:filter, %{player_name: name}}, query ->
        where(query, [player], ilike(player.name, ^"%#{name}%"))
    end)
  end
end
