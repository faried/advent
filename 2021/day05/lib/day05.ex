defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """

  def part1(input) do
    input
    |> tracks(%{})
  end

  def part2(input) do
    input
    |> tracks(%{}, :diag)
  end

  defp tracks(lines, floor, diag \\ nil)

  defp tracks([], floor, _), do: Enum.count(floor, fn {_pos, overlaps} -> overlaps > 1 end)

  defp tracks([line | lines], floor, diag) do
    floor =
      trace(line, diag)
      |> draw(floor)

    tracks(lines, floor, diag)
  end

  defp trace(line, diag) do
    [x1, y1, x2, y2] =
      String.split(line, " -> ")
      |> Enum.flat_map(&String.split(&1, ","))
      |> Enum.map(&String.to_integer/1)

    cond do
      y1 == y2 ->
        (Enum.intersperse(x1..x2, y1) ++ [y1])
        |> Enum.chunk_every(2)

      x1 == x2 ->
        (Enum.intersperse(y1..y2, x1) ++ [x1])
        |> Enum.chunk_every(2)
        |> Enum.map(&Enum.reverse/1)

      diag ->
        Enum.zip(x1..x2, y1..y2)
        |> Enum.map(&Tuple.to_list/1)

      true ->
        []
    end
  end

  def draw([], floor), do: floor

  def draw([[x, y] | points], floor) do
    {_, floor} =
      Map.get_and_update(floor, {x, y}, fn cur -> if !cur, do: {cur, 1}, else: {cur, cur + 1} end)

    draw(points, floor)
  end
end
