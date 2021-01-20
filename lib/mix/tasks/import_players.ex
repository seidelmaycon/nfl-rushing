defmodule Mix.Tasks.ImportPlayers do
  @moduledoc """
  Mix task to import a json file of players stats
  e.g. "mix import_players rushing.json"
  """
  use Mix.Task

  alias NflRushing.Import.Players

  def run(filename) do
    Mix.Task.run("app.start")

    {:ok, count} = Players.insert_players_from_json_file(filename)
    count
  end
end
