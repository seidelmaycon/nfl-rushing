defmodule NflRushing.Stats do
  @moduledoc """
  Interface to manipulate Stats.Players data
  """
  import Ecto.Query

  alias NflRushing.Stats.Player
  alias NflRushing.Repo

  def list_players(criteria) when is_list(criteria) do
    query = from(p in Player)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from p in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from p in query, order_by: [{^sort_order, ^sort_by}]

      {:filter, %{player_name: name}}, query ->
        where(query, [player], ilike(player.name, ^"%#{name}%"))
    end)
    |> Repo.all()
  end
end
