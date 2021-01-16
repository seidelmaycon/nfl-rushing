defmodule NflRushing.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :team, :string
      add :position, :string
      add :rushing_attemps_game_average, :float
      add :rushing_attemps_total, :integer
      add :rushing_yards_total, :float
      add :rushing_yards_attempt_average, :float
      add :rushing_yards_game_average, :float
      add :rushing_touchdown_total, :integer
      add :longest_rush_yards, :float
      add :longest_rush_with_touchdown, :boolean, default: false, null: false
      add :first_downs_total, :integer
      add :first_down_percentage, :float
      add :rushing_over_twenty_yards_count, :integer
      add :rushing_over_forty_yards_count, :integer
      add :rushing_fumbles, :integer
    end

    create index(:players, :name)
    create index(:players, :rushing_yards_total)
    create index(:players, :rushing_touchdown_total)
    create index(:players, :longest_rush_yards)
  end
end
