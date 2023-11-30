defmodule Day18 do
  @moduledoc """
  Documentation for `Day18`.
  """

  def part1(input) do
    input
    |> to_facemap()
    |> Map.values()
    |> Enum.sum()

  end

  def part2(input) do
    faces = part1(input)

    {xmin, xmax} =
      input
      |> Enum.map(fn {x, _, _} -> x end)
      |> Enum.min_max()

    {ymin, ymax} =
      input
      |> Enum.map(fn {_, y, _} -> y end)
      |> Enum.min_max()

    {zmin, zmax} =
      input
      |> Enum.map(fn {_, _, z} -> z end)
      |> Enum.min_max()

    cubeset =
      input
      |> Enum.reduce(MapSet.new(), fn cube, acc -> MapSet.put(acc, cube) end)

    inside =
      Enum.flat_map(xmin..xmax, fn x ->
        Enum.flat_map(ymin..ymax, fn y ->
          Enum.map(zmin..zmax, fn z ->
            if {x, y, z} not in cubeset and is_inside({x, y, z}, cubeset, xmin, xmax, ymin, ymax, zmin, zmax) do
              IO.inspect({x, y, z}, label: "hole")
            else
              nil
            end
          end)
        end)
      end)
      |> Enum.filter(fn x -> x != nil end)
    |> part1()

    # too low
    faces - inside
  end

  def is_inside({x, y, z}, cubeset, xmin, xmax, ymin, ymax, zmin, zmax) do
    if x in [xmin, xmax] or y in [ymin, ymax] or z in [zmin, zmax] do
      false
    else
      xmin? = Enum.any?(x-1..xmin//-1, fn i -> {i, y, z} in cubeset end)
      xmax? = Enum.any?(x+1..xmax, fn i -> {i, y, z} in cubeset end)
      ymin? = Enum.any?(y-1..ymin//-1, fn j -> {x, j, z} in cubeset end)
      ymax? = Enum.any?(y+1..ymax, fn j -> {x, j, z} in cubeset end)
      zmin? = Enum.any?(z-1..zmin//-1, fn k -> {x, y, k} in cubeset end)
      zmax? = Enum.any?(z+1..zmax, fn k -> {x, y, k} in cubeset end)
      Enum.all?([xmin?, xmax?, ymin?, ymax?, zmin?, zmax?])
    end
  end

  def to_facemap(cubes) do
    faces = Enum.reduce(cubes, %{}, fn cube, acc -> Map.put(acc, cube, 6) end)

    cubes
    # so inefficient
    |> Enum.reduce(faces, fn {x, y, z} = cube, acc ->
      xtouch = Enum.count(cubes, fn {cx, cy, cz} = cube2 ->
      cube != cube2 and cy == y and cz == z and abs(cx - x) == 1
    end)
      ytouch = Enum.count(cubes, fn {cx, cy, cz} = cube2 ->
        cube != cube2 and cx == x and cz == z and abs(cy - y) == 1
      end)
      ztouch = Enum.count(cubes, fn {cx, cy, cz} = cube2 ->
        cube != cube2 and cx == x and cy == y and abs(cz - z) == 1
      end)
      Map.update!(acc, cube, fn e -> e - (xtouch + ytouch + ztouch) end)
    end)
  end


  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end)
  end

end
