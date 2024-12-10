defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

  def part1(grid) do
    path_to_zero(grid)
    |> Enum.reduce(MapSet.new(), fn trail, acc ->
      MapSet.put(acc, {List.first(trail), List.last(trail)})
    end)
    |> Enum.count()
  end

  def part2(grid) do
    path_to_zero(grid)
    |> Enum.count()
  end

  def path_to_zero(grid) do
    {:ok, pid} = Agent.start(fn -> MapSet.new() end)

    find_nines(grid)
    |> Enum.each(&find_zero(grid, pid, &1))

    Agent.get(pid, fn acc -> acc end)
  end

  def find_nines(grid), do: Enum.filter(grid, &(elem(&1, 1) == 9))

  def find_zero(grid, pid, {pos, _height}), do: find_zero(grid, pid, pos, [pos])

  def find_zero(grid, pid, pos, path) do
    find_lower_neighbors(grid, pos)
    |> Enum.each(fn
      :done -> Agent.update(pid, fn acc -> MapSet.put(acc, path) end)
      next -> find_zero(grid, pid, next, [next | path])
    end)
  end

  def find_lower_neighbors(grid, {r, c}) do
    height = Map.get(grid, {r, c})

    if height == 0 do
      [:done]
    else
      [{r - 1, c}, {r + 1, c}, {r, c - 1}, {r, c + 1}]
      |> Enum.filter(fn pos -> Map.get(grid, pos) == height - 1 end)
    end
  end

  def to_grid(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, rownum} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reject(&(elem(&1, 0) == "."))
      |> Enum.map(fn {cell, colnum} ->
        {{rownum, colnum}, String.to_integer(cell)}
      end)
    end)
    |> Map.new()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> to_grid()
  end
end
