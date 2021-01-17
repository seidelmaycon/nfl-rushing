defmodule NflRushing.Stats.Player do
  @moduledoc """
  Map players records to %Player{} struct.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @fields [
    :name,
    :team,
    :position,
    :rushing_attemps_game_average,
    :rushing_attemps_total,
    :rushing_yards_total,
    :rushing_yards_attempt_average,
    :rushing_yards_game_average,
    :rushing_touchdown_total,
    :longest_rush_yards,
    :longest_rush_with_touchdown,
    :first_downs_total,
    :first_down_percentage,
    :rushing_over_twenty_yards_count,
    :rushing_over_forty_yards_count,
    :rushing_fumbles
  ]

  schema "players" do
    field :name, :string
    field :team, :string
    field :position, :string
    field :rushing_attemps_game_average, :float
    field :rushing_attemps_total, :integer
    field :rushing_yards_total, :float
    field :rushing_yards_attempt_average, :float
    field :rushing_yards_game_average, :float
    field :rushing_touchdown_total, :integer
    field :longest_rush_yards, :float
    field :longest_rush_with_touchdown, :boolean, default: false
    field :first_downs_total, :integer
    field :first_down_percentage, :float
    field :rushing_over_twenty_yards_count, :integer
    field :rushing_over_forty_yards_count, :integer
    field :rushing_fumbles, :integer
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, @fields)
    |> validate_length(:name, max: 255)
    |> validate_length(:team, max: 255)
    |> validate_length(:position, max: 255)
  end
end
