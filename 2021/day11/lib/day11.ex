defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  def part1(input, steps \\ 100) do
    {map, maxrows, maxcols} = to_map(input)

    step({map, 0}, maxrows, maxcols, steps)
    |> elem(1)
  end

  def part2(input) do
    {map, maxrows, maxcols} = to_map(input)

    until_all_flash(map, maxrows, maxcols)
  end

  defp until_all_flash(map, maxrows, maxcols, step_count \\ 1)

  defp until_all_flash(map, maxrows, maxcols, step_count) do
    {newmap, _} = step({map, 0}, maxrows, maxcols, 1)

    if all_flash?(newmap),
      do: step_count,
      else: until_all_flash(newmap, maxrows, maxcols, step_count + 1)
  end

  defp all_flash?(map), do: Enum.all?(map, fn {_, octopus} -> octopus == 0 end)

  defp step({map, flashes}, _, _, 0), do: {map, flashes}

  defp step({map, flashes}, mr, mc, count) do
    map
    |> energy(mr, mc)
    |> flash(flashes, mr, mc, MapSet.new())
    |> step(mr, mc, count - 1)
  end

  defp energy(map, mr, mc) do
    for(r <- 0..(mr - 1), c <- 0..(mc - 1), do: {{r, c}, map[{r, c}] + 1})
    |> Map.new()
  end

  # this is complicated
  # 1. it loops through the map, and finds any > 9 octopuses that have not already
  # flashed in the current step
  # 2. it puts each such octopus's position in the flashed set
  # 3. it builds a list of {{pos}, adj(pos)} pairs for each octopus
  # 4. it calls do_update with the map and the updatelist, which returns an updated map
  # 5. if the updated map is not the same as the map we're given, run it again (it might
  #    have new > 9 octopuses)
  defp flash(map, flashes, mr, mc, flashed) do
    {adjlist, newflash} =
      Enum.reduce(map, {[], flashed}, fn {{r, c}, octopus}, {acc, flashed} ->
        if octopus > 9 and {r, c} not in flashed do
          {[{{r, c}, adj(map, r, c)} | acc], MapSet.put(flashed, {r, c})}
        else
          {acc, flashed}
        end
      end)

    {newmap, flashes} = do_update(map, flashes, adjlist, newflash)

    if map != newmap do
      flash(newmap, flashes, mr, mc, newflash)
    else
      {newmap, flashes}
    end
  end

  defp do_update(map, flashes, [], _flashed), do: {map, flashes}

  # for each adjacent position to the flashing octopus,
  # increment their energy level (unless they've already flashed)
  defp do_update(map, flashes, [{pos, adjpos} | octopuses], flashed) do
    map = Map.put(map, pos, 0)

    newmap =
      Enum.reduce(adjpos, map, fn pos, acc ->
        if pos in flashed do
          acc
        else
          Map.put(acc, pos, 1 + Map.get(acc, pos))
        end
      end)

    do_update(newmap, flashes + 1, octopuses, flashed)
  end

  defp adj(m, r, c) do
    [
      {r, c + 1},
      {r, c - 1},
      {r - 1, c},
      {r + 1, c},
      {r + 1, c + 1},
      {r + 1, c - 1},
      {r - 1, c + 1},
      {r - 1, c - 1}
    ]
    |> Enum.filter(fn key -> Map.has_key?(m, key) end)
  end

  defp to_map(input) do
    rows = String.split(input, "\n", trim: true)
    maxrows = Enum.count(rows)
    maxcols = String.length(Enum.at(rows, 0))

    map =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, rownum} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {octopus, colnum} ->
          {{rownum, colnum}, String.to_integer(octopus)}
        end)
      end)
      |> Map.new()

    {map, maxrows, maxcols}
  end
end
