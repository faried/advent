defmodule Day04 do
  @moduledoc """
  Documentation for `Day04`.
  """

  def part1(ranges) do
    Enum.reduce(ranges, 0, fn [elf1, elf2], count ->
      if MapSet.subset?(elf1, elf2), do: count + 1, else: count
    end)
  end

  def part2(ranges) do
    Enum.reduce(ranges, 0, fn [elf1, elf2], count ->
      if MapSet.disjoint?(elf1, elf2), do: count, else: count + 1
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn ranges ->
      [elf1, elf2] =
        String.split(ranges, ",")
        |> Enum.map(&to_rangeset/1)

      if MapSet.size(elf1) > MapSet.size(elf2), do: [elf2, elf1], else: [elf1, elf2]
    end)
  end

  defp to_rangeset(rangestr) do
    [first, last] =
      String.split(rangestr, "-")
      |> Enum.map(&String.to_integer/1)

    MapSet.new(first..last)
  end
end
