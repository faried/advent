defmodule Day06 do
  @moduledoc """
  Documentation for `Day06`.
  """

  def part1(input), do: find_sequence(input, 4)
  def part2(input), do: find_sequence(input, 14)

  defp find_sequence(input, length) do
    try do
      input
      |> String.graphemes()
      |> Enum.chunk_every(length, 1, :discard)
      |> Enum.with_index()
      |> Enum.map(fn {maybe, idx} ->
        elements =
          MapSet.new(maybe)
          |> MapSet.size()

        # yeah yeah
        if elements == length, do: throw(idx + length)
      end)
    catch
      pos -> pos
    end
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.trim()
  end
end
