defmodule NflRushing.Import.Players do
  @moduledoc """
  Loads players from a json file and insert all in the database
  """

  alias NflRushing.Import.Players.{Handler, Parser}

  def insert_players_from_json_file(file_name) do
    with {:ok, records} <- Parser.from_json(file_name),
         {:ok, count} <- Handler.insert_all(records) do
      {:ok, count}
    end
  end
end
