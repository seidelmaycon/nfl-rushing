defmodule NflRushingWeb.PlayerStatsLive.Index do
  @moduledoc false
  use NflRushingWeb, :live_view

  alias NflRushing.Stats

  @per_page 15

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        update_action: "append",
        page: 1,
        per_page: @per_page,
        sort_by: :id,
        sort_order: :asc,
        player_name: ""
      )
      |> load_more_players()

    {:ok, socket, temporary_assigns: [players: []]}
  end

  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> load_more_players()
      |> assign(update_action: "append")

    {:noreply, socket}
  end

  def handle_event("player-name-search", %{"player" => %{"name" => name}}, socket) do
    send(self(), {:run_player_name_search, name})

    socket =
      socket
      |> assign(player_name: name, players: [], update_action: "replace")
      |> load_more_players()

    {:noreply, socket}
  end

  def handle_params(params, _url, socket) do
    options = %{
      sort_by: (params["sort_by"] || "id") |> String.to_atom(),
      sort_order: (params["sort_order"] || "asc") |> String.to_atom(),
      page: String.to_integer(params["page"] || "1"),
      per_page: @per_page,
      player_name: socket.assigns.player_name || ""
    }

    socket =
      search_players(socket, options)
      |> assign(update_action: "replace")

    {:noreply, socket}
  end

  def handle_info({:run_player_name_search, name}, socket) do
    %{
      sort_by: socket.assigns.sort_by || :id,
      sort_order: socket.assigns.sort_order || :asc,
      page: 1,
      per_page: @per_page,
      player_name: name
    }
    |> list_players()
    |> case do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No players matching \"#{name}\"")
          |> assign(players: [])

        {:noreply, socket}

      players ->
        socket = assign(socket, players: players)
        {:noreply, socket}
    end
  end

  defp load_more_players(socket) do
    search_players(socket, %{
      page: socket.assigns.page || 1,
      per_page: socket.assigns.per_page || @per_page,
      sort_by: socket.assigns.sort_by || :id,
      sort_order: socket.assigns.sort_order || :asc,
      player_name: socket.assigns.player_name || ""
    })
  end

  defp search_players(socket, options) do
    players = list_players(options)

    assign(socket, Map.put(options, :players, players))
  end

  defp list_players(options) do
    Stats.list_players(
      paginate: %{page: options.page, per_page: options.per_page},
      sort: %{sort_by: options.sort_by, sort_order: options.sort_order},
      filter: %{player_name: options.player_name}
    )
  end

  defp sort_link(socket, text, sort_by, options) do
    live_patch(text,
      to:
        Routes.player_stats_index_path(
          socket |> assign(update_action: "replace"),
          :index,
          sort_by: sort_by,
          sort_order: toggle_sort_order(options.sort_order),
          page: 1,
          per_page: @per_page
        )
    )
  end

  defp toggle_sort_order(:asc), do: :desc
  defp toggle_sort_order(:desc), do: :asc
end
