defmodule Day03 do
  @moduledoc """
  Documentation for `Day03`.
  """

  def part1(input, priorities \\ 0)

  def part1([], priorities), do: priorities

  def part1([rucksack | rest], priorities) do
    priority =
      String.to_charlist(rucksack)
      |> Enum.chunk_every(div(String.length(rucksack), 2))
      |> Enum.map(&MapSet.new/1)
      |> common()

    part1(rest, priorities + priority)
  end

  def part2(input) do
    input
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, fn rucksacks, acc -> acc + common(rucksacks) end)
  end

  # part1 calls it with two list items, part2 with three
  defp common([first | rest]) do
    val =
      Enum.reduce(rest, first, fn item, acc -> MapSet.intersection(item, acc) end)
      |> MapSet.to_list()
      |> hd()

    cond do
      val > ?a -> val - ?a + 1
      val > ?A -> val - ?A + 27
    end
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end
end
