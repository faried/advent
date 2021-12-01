defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """

  def part1(numls) do
    Enum.reduce(numls, {List.first(numls), 0}, fn x, {prev, count} ->
      if x > prev, do: {x, count+1}, else: {x, count}
    end)
    |> elem(1)
  end

  def part2(numls) do
    Stream.chunk_every(numls, 3, 1, :discard)
    |> Enum.map(&Enum.sum/1)
    |> part1()
  end
end
