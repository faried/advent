defmodule Day24 do
  @dirs %{
    "w" => {0, -1},
    "e" => {0, 1},
    "nw" => {0.5, -0.5},
    "ne" => {0.5, 0.5},
    "se" => {-0.5, 0.5},
    "sw" => {-0.5, -0.5}
  }

  def readinput() do
    File.read!("24.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.scan(~r/(se|ne|sw|nw|w|e)/, line, capture: :all_but_first)
      |> List.flatten()
      |> Enum.map(&Map.get(@dirs, &1))
    end)
  end

  def part1(input \\ readinput()) do
    flip(input, %{{0, 0} => :white})
    |> blacktiles()
  end

  def flip([], floor), do: floor

  def flip([path | paths], floor) do
    tile = Enum.reduce(path, {0, 0}, fn {ns, ew}, {nsacc, ewacc} -> {nsacc + ns, ewacc + ew} end)

    case Map.get(floor, tile, :white) do
      :black -> flip(paths, Map.put(floor, tile, :white))
      :white -> flip(paths, Map.put(floor, tile, :black))
    end
  end

  def blacktiles(floor) do
    floor
    |> Map.values()
    |> Enum.count(&(&1 == :black))
  end

  def part2(input \\ readinput()) do
    flip(input, %{{0, 0} => :white})
    |> dayflip(100)
    |> blacktiles()
  end

  def dayflip(floor, 0), do: floor

  def dayflip(floor, count) do
    expand(floor)
    |> Enum.reduce(%{}, fn {tile, color} = t, newfloor ->
      blacks =
        adjtiles(tile)
        |> Enum.map(&Map.get(floor, &1))
        |> Enum.count(&(&1 == :black))

      cond do
        color == :black and (blacks == 0 or blacks > 2) ->
          Map.put(newfloor, tile, :white)

        color == :white and blacks == 2 ->
          Map.put(newfloor, tile, :black)

        true ->
          if t in floor, do: Map.put(newfloor, tile, color), else: newfloor
      end
    end)
    |> dayflip(count - 1)
  end

  def expand(floor) do
    floor
    |> Enum.flat_map(fn {tile, _} -> adjtiles(tile) end)
    |> MapSet.new()
    |> Enum.reduce(%{}, fn tile, newfloor ->
      Map.put(newfloor, tile, Map.get(floor, tile, :white))
    end)
  end

  def adjtiles({ns, ew}) do
    [
      {ns + 0.5, ew + 0.5},
      {ns + 0.5, ew - 0.5},
      {ns - 0.5, ew + 0.5},
      {ns - 0.5, ew - 0.5},
      {ns, ew + 1},
      {ns, ew - 1}
    ]
  end
end
