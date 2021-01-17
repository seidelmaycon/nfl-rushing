defmodule NflRushing.Import.Players.Parser do
  @moduledoc """
  Convert a given data source to parsed array of players.
  """

  @fields [
    {"Player", {:name, :string}},
    {"Team", {:team, :string}},
    {"Pos", {:position, :string}},
    {"Att/G", {:rushing_attemps_game_average, :float}},
    {"Att", {:rushing_attemps_total, :integer}},
    {"Yds", {:rushing_yards_total, :float}},
    {"Avg", {:rushing_yards_attempt_average, :float}},
    {"Yds/G", {:rushing_yards_game_average, :float}},
    {"TD", {:rushing_touchdown_total, :integer}},
    {"Lng", {:longest_rush_yards, :float}},
    {"1st", {:first_downs_total, :integer}},
    {"1st%", {:first_down_percentage, :float}},
    {"20+", {:rushing_over_twenty_yards_count, :integer}},
    {"40+", {:rushing_over_forty_yards_count, :integer}},
    {"FUM", {:rushing_fumbles, :integer}}
  ]

  def from_json(file_name) do
    with {:ok, binary} <- File.read(file_name),
         {:ok, records} when is_list(records) <- Jason.decode(binary) do
      {:ok, parse_all_records(records)}
    else
      _ -> {:error, "Invalid JSON"}
    end
  end

  defp parse_all_records(records) do
    Enum.reduce(records, [], &[parse_record(&1) | &2])
  end

  defp parse_record(record) do
    Enum.reduce(@fields, %{}, &Map.merge(&2, parse_field(record, &1)))
  end

  defp parse_field(%{"Lng" => value}, {"Lng", {:longest_rush_yards, type}})
       when is_binary(value) do
    case String.ends_with?(value, "T") do
      true -> %{longest_rush_with_touchdown: true}
      false -> %{}
    end
    |> Map.merge(%{longest_rush_yards: parse_value_to(type, value)})
  end

  defp parse_field(record, {file_key, {db_key, type}}) do
    value = Map.get(record, file_key)

    %{db_key => parse_value_to(type, value)}
  end

  defp parse_value_to(:float, value) when is_integer(value), do: value * 1.0
  defp parse_value_to(:float, value) when is_binary(value), do: Float.parse(value) |> elem(0)
  defp parse_value_to(:integer, value) when is_binary(value), do: Integer.parse(value) |> elem(0)
  defp parse_value_to(_, value), do: value
end
