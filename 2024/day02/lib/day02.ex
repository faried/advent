defmodule Day02 do
  @moduledoc """
  Documentation for `Day02`.
  """

  def part1(input), do: Enum.count(input, &safe?/1)

  def part2(input) do
    Enum.count(input, fn levels ->
      if safe?(levels) do
        true
      else
        len = Enum.count(levels)

        # remove one item at a time until it is safe or
        # we run out of items to remove
        Enum.reduce_while(0..len, false, fn idx, _acc ->
          new_levels = List.delete_at(levels, idx)

          if safe?(new_levels), do: {:halt, true}, else: {:cont, false}
        end)
      end
    end)
  end

  def safe_difference?(a, b) do
    diff = abs(a - b)

    diff > 0 and diff <= 3
  end

  def direction(a, b) do
    cond do
      a > b -> :desc
      a < b -> :asc
      a == b -> nil
    end
  end

  def safe?(levels) do
    [first | rest] = levels
    asc_desc = direction(first, hd(rest))

    # return early
    if is_nil(asc_desc) or !safe_difference?(first, hd(rest)) do
      false
    else
      Enum.reduce_while(rest, {:safe, first, asc_desc}, fn level, {safe, prev, dir} ->
        newdir = direction(prev, level)

        if newdir == dir and safe_difference?(prev, level) do
          {:cont, {safe, level, dir}}
        else
          {:halt, {:unsafe, level, dir}}
        end
      end)
      |> then(fn {safe_unsafe, _, _} -> safe_unsafe == :safe end)
    end
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
