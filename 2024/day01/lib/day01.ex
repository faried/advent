defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """

  def part1({first, second}) do
    first = Enum.sort(first)
    second = Enum.sort(second)

    Enum.zip_reduce(first, second, 0, fn f, s, acc ->
      acc + abs(f - s)
    end)
  end

  def part2({first, second}) do
    Enum.reduce(first, 0, fn f, acc ->
      acc + f * Enum.count(second, fn s -> s == f end)
    end)
  end

  def read_input(fname) do
    [first, second] =
      File.read!("priv/#{fname}")
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    {first, second}
  end
end
