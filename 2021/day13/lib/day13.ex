defmodule Day13 do
  @moduledoc """
  Documentation for `Day13`.
  """

  def part1(input) do
    {floor, folds} =
      input
      |> build_floor()

    fold(floor, [List.first(folds)])
    # |> print_floor()
    |> count_dots()
  end

  def part2(input) do
    {floor, folds} =
      input
      |> build_floor()

    fold(floor, folds)
    |> print_floor()
  end

  def count_dots(floor) do
    Map.values(floor) |> length()
  end

  defp print_floor(floor) do
    maxx =
      Map.keys(floor)
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    maxy =
      Map.keys(floor)
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    IO.puts("")

    for(y <- 0..maxy, x <- 0..maxx, do: Map.get(floor, {x, y}, "."))
    |> Enum.chunk_every(maxx + 1)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts/1)

    floor
  end

  defp fold(floor, []), do: floor

  defp fold(floor, [{axis, coord} | folds]) do
    Enum.reduce(Map.keys(floor), floor, fn {x, y}, newfloor ->
      cond do
        axis == "x" and x > coord ->
          newfloor
          |> Map.delete({x, y})
          |> Map.put({coord - (x - coord), y}, "#")

        axis == "y" and y > coord ->
          newfloor
          |> Map.delete({x, y})
          |> Map.put({x, coord - (y - coord)}, "#")

        true ->
          newfloor
      end
    end)
    |> fold(folds)
  end

  defp build_floor(input) do
    {floor, folds} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({%{}, []}, fn line, {floor, folds} ->
        if String.starts_with?(line, "fold") do
          [axis, coord] =
            String.split(line)
            |> Enum.at(2)
            |> String.split("=")

          {floor, [{axis, String.to_integer(coord)} | folds]}
        else
          [x, y] =
            line
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)

          {Map.put(floor, {x, y}, "#"), folds}
        end
      end)

    {floor, Enum.reverse(folds)}
  end
end
