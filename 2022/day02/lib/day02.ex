defmodule Day02 do
  @moduledoc """
  Documentation for `Day02`.
  """

  @scores1 %{
    "X" => 1,
    "Y" => 2,
    "Z" => 3,
    :lose => 0,
    :draw => 3,
    :win => 6
  }

  @scores2 %{
    "A" => 1,
    "B" => 2,
    "C" => 3,
    "X" => 0,
    "Y" => 3,
    "Z" => 6
  }

  def part1(input, score \\ 0)

  def part1([], score), do: score

  def part1([[them, us] | rounds], score) do
    roundscore = @scores1[outcome(them, us)] + @scores1[us]
    part1(rounds, score + roundscore)
  end

  def part2(input, score \\ 0)

  def part2([], score), do: score

  def part2([[them, outcome] | rounds], score) do
    roundscore = @scores2[outcome] + @scores2[shape(them, outcome)]
    part2(rounds, score + roundscore)
  end

  defp outcome(them, us) do
    case {them, us} do
      {"A", "X"} -> :draw
      {"A", "Y"} -> :win
      {"A", "Z"} -> :lose
      {"B", "X"} -> :lose
      {"B", "Y"} -> :draw
      {"B", "Z"} -> :win
      {"C", "X"} -> :win
      {"C", "Y"} -> :lose
      {"C", "Z"} -> :draw
    end
  end

  defp shape(them, outcome) do
    case {them, outcome} do
      {"A", "X"} -> "C"
      {"A", "Y"} -> "A"
      {"A", "Z"} -> "B"
      {"B", "X"} -> "A"
      {"B", "Y"} -> "B"
      {"B", "Z"} -> "C"
      {"C", "X"} -> "B"
      {"C", "Y"} -> "C"
      {"C", "Z"} -> "A"
    end
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
    end)
  end
end
