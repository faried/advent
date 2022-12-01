defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """

  def part1(input) do
    input
    |> prepare()
    |> hd()
  end

  def part2(input) do
    input
    |> prepare()
    |> Enum.take(3)
    |> Enum.sum()
  end

  defp prepare(input) do
    input
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
  end
end
