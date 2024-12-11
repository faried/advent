defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  def part1(input), do: loop(input, 25)

  def part2(input), do: loop(input, 75)

  def loop(input, n) when is_list(input) do
    Enum.reduce(input, %{}, fn stone, acc -> Map.put(acc, stone, 1) end)
    |> loop(n)
  end

  def loop(input, 0) do
    input
    |> Map.values()
    |> Enum.sum()
  end

  def loop(input, n) do
    Enum.reduce(input, %{}, fn {stone, count}, acc ->
      cond do
        stone == 0 ->
          Map.update(acc, 1, count, fn e -> e + count end)

        rem(length(Integer.digits(stone)), 2) == 0 ->
          {left, right} =
            Integer.to_string(stone)
            |> String.split_at(div(length(Integer.digits(stone)), 2))

          left = String.to_integer(left)
          right = String.to_integer(right)

          Map.update(acc, left, count, fn e -> e + count end)
          |> Map.update(right, count, fn e -> e + count end)

        true ->
          Map.update(acc, stone * 2024, count, fn e -> e + count end)
      end
    end)
    |> loop(n - 1)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
