defmodule NflRushing.Stats.PlayerTest do
  use NflRushing.DataCase, async: true

  alias NflRushing.Stats.Player

  describe "changeset/2" do
    test "with valid attributes changeset is valid" do
      assert %Ecto.Changeset{errors: [], valid?: true} = changeset(params_for(:player))
    end

    test "with invalid strings changeset is invalid" do
      changeset =
        params_for(:player,
          name: String.duplicate("a", 256),
          team: String.duplicate("a", 256),
          position: String.duplicate("a", 256)
        )
        |> changeset()

      refute changeset.valid?

      assert %{
               name: ["should be at most 255 character(s)"],
               position: ["should be at most 255 character(s)"],
               team: ["should be at most 255 character(s)"]
             } == errors_on(changeset)
    end
  end

  defp changeset(params), do: Player.changeset(%Player{}, params)
end
