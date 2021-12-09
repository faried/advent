defmodule Day09 do
  @moduledoc """
  Documentation for `Day09`.
  """

  def part1(input) do
    maxrows = Enum.count(input)
    maxcols = Enum.count(Enum.at(input, 0))

    input
    |> to_map()
    |> find_lows(maxrows, maxcols, :heights)
    |> Enum.map(&(&1 + 1))
    |> Enum.sum()
  end

  def part2(input) do
    maxrows = Enum.count(input)
    maxcols = Enum.count(Enum.at(input, 0))

    seafloor = to_map(input)

    find_lows(seafloor, maxrows, maxcols, :positions)
    |> Enum.map(&find_basin([&1], MapSet.new(), seafloor, maxrows, maxcols))
    |> Enum.sort(fn a, b -> a > b end)
    |> Enum.take(3)
    |> Enum.reduce(&*/2)
  end

  # could be better
  defp to_map(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {row, ridx} ->
      row
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {height, cidx}, map -> Map.put(map, {ridx, cidx}, height) end)
    end)
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)
  end

  defp around({r, c}, maxrows, maxcols) do
    [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}]
    |> Enum.filter(fn {r, c} -> r >= 0 and r < maxrows and c >= 0 and c < maxcols end)
  end

  defp find_lows(seafloor, maxrows, maxcols, what) do
    Enum.reduce(seafloor, [], fn {{r, c}, height}, lows ->
      maybe =
        around({r, c}, maxrows, maxcols)
        |> Enum.map(fn {r, c} -> Map.get(seafloor, {r, c}) end)
        |> Enum.all?(fn h -> height < h end)

      cond do
        maybe and what == :heights -> [height | lows]
        maybe and what == :positions -> [{r, c} | lows]
        true -> lows
      end
    end)
  end

  defp find_basin([], seen, _seafloor, _maxrows, _maxcols), do: Enum.count(seen)

  defp find_basin([{r, c} | locations], seen, seafloor, maxrows, maxcols) do
    more =
      around({r, c}, maxrows, maxcols)
      |> Enum.filter(fn {r, c} -> {r, c} not in seen end)
      |> Enum.filter(fn {r, c} -> Map.get(seafloor, {r, c}) < 9 end)

    find_basin(
      more ++ locations,
      MapSet.union(seen, MapSet.new(more)),
      seafloor,
      maxrows,
      maxcols
    )
  end
end
