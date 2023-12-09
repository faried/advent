defmodule Day09 do
  def part1(input) do
    Enum.map(input, fn nums ->
      find_next(nums)
      |> Enum.map(&List.last/1)
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, fn nums ->
      find_next(nums)
      |> Enum.map(&hd/1)
      |> Enum.reduce(0, fn num, acc -> num - acc end)
    end)
    |> Enum.sum()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> parse()
  end

  defp parse(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp find_next(nums, acc \\ []) do
    if Enum.all?(nums, &(&1 == 0)) do
      acc
    else
      diffs(nums)
      |> find_next([nums | acc])
    end
  end

  defp diffs(nums) do
    nums
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [first, second] -> second - first end)
  end
end
