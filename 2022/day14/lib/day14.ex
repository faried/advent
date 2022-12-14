defmodule Day14 do
  @moduledoc """
  Documentation for `Day14`.
  """

  @sandpos {500, 0}
  @rock "R"
  @sand "o"
  @source "+"
  @empty "."

  def part1(cave) do
    floor =
      cave
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    drop_sand(cave, floor, @sandpos)
  end

  def part2(cave) do
    real_floor =
      cave
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()
      |> Kernel.+(2)

    {xmin, xmax} =
      cave
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    # draw a wide fake floor and drop sand
    draw_line(cave, [xmin - 5000, real_floor], [xmax + 5000, real_floor])
    |> drop_sand(real_floor, @sandpos)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> then(&to_cave(%{}, &1))
  end

  def to_cave(cave, []), do: cave

  def to_cave(cave, [path | paths]) do
    lines =
      path
      |> String.split(" -> ")
      |> Enum.chunk_every(2, 1, :discard)

    Enum.reduce(lines, cave, fn [s, e], acc ->
      spos =
        s
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      epos =
        e
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      draw_line(acc, spos, epos)
    end)
    |> to_cave(paths)
  end

  # same "row"
  def draw_line(cave, [x, y1], [x, y2]) do
    Enum.reduce(y1..y2, cave, fn y, acc ->
      Map.put(acc, {x, y}, @rock)
    end)
  end

  # same "column"
  def draw_line(cave, [x1, y], [x2, y]) do
    Enum.reduce(x1..x2, cave, fn x, acc ->
      Map.put(acc, {x, y}, @rock)
    end)
  end

  def drop_sand(cave, maxy, sandpos, sand \\ 0)

  # part 1 - dropped into the abyss
  def drop_sand(_cave, maxy, {_sx, sy}, sand) when sy > maxy, do: sand

  def drop_sand(cave, maxy, {sx, sy}, sand) do
    if Map.get(cave, {sx, sy + 1}) == nil do
      drop_sand(cave, maxy, {sx, sy + 1}, sand)
    else
      left = Map.get(cave, {sx - 1, sy + 1})
      right = Map.get(cave, {sx + 1, sy + 1})

      cond do
        left == nil ->
          drop_sand(cave, maxy, {sx - 1, sy + 1}, sand)

        right == nil ->
          drop_sand(cave, maxy, {sx + 1, sy + 1}, sand)

        left != nil and right != nil ->
          if {sx, sy} == @sandpos do
            # part 2 - pile of sand has reached the source
            sand + 1
          else
            # place sand, recurse
            Map.put(cave, {sx, sy}, @sand)
            |> drop_sand(maxy, @sandpos, sand + 1)
          end
      end
    end
  end

  def draw_cave(cave) do
    coords = Map.keys(cave)

    {xmin, xmax} =
      coords
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    floor =
      coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    Enum.map_join(0..floor, "\n", fn y ->
      Enum.reduce((xmin - 1)..(xmax + 1), [], fn x, acc ->
        # draw point where sand enters the cave
        if {x, y} == @sandpos,
          do: [@source | acc],
          else: ["#{Map.get(cave, {x, y}, @empty)}" | acc]
      end)
      |> Enum.reverse()
      |> Enum.join("")
    end)
    |> IO.puts()
  end
end
