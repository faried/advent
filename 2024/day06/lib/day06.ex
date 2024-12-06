defmodule Day06 do
  @moduledoc """
  Documentation for `Day06`.
  """

  # {r, c} deltas
  @up {-1, 0}
  @down {1, 0}
  @left {0, -1}
  @right {0, 1}

  @rotate %{
    @up => @right,
    @right => @down,
    @down => @left,
    @left => @up
  }

  def part1({start_pos, grid}) do
    path(start_pos, grid, @up, MapSet.new())
    |> Enum.count()
  end

  # for each position in the path (except the starting position),
  # try placing an obstruction and see if we hit a cycle.
  def part2({start_pos, grid}) do
    possibilities =
      path(start_pos, grid, @up, MapSet.new())
      |> MapSet.delete(start_pos)

    # IO.puts("positions to try: #{Enum.count(possibilities)}")

    possibilities
    |> Enum.reduce(MapSet.new(), fn obspos, acc ->
      case path(start_pos, Map.put(grid, obspos, "#"), @up, MapSet.new()) do
        :cycle ->
          MapSet.put(acc, obspos)

        _ ->
          acc
      end
    end)
    |> Enum.count()
  end

  def can_move?({r, c}, grid, {rd, cd}) do
    Map.get(grid, {r + rd, c + cd}) != "#"
  end

  def path({r, c} = pos, grid, {rd, cd} = dir, sofar) do
    cond do
      is_nil(Map.get(grid, pos)) ->
        # done
        Enum.map(sofar, &elem(&1, 0))
        |> MapSet.new()

      {pos, dir} in sofar ->
        # this never occurs in part 1
        :cycle

      can_move?(pos, grid, dir) ->
        path({r + rd, c + cd}, grid, dir, MapSet.put(sofar, {pos, dir}))

      true ->
        # obstacle up ahead
        path(pos, grid, @rotate[dir], sofar)
    end
  end

  def read_input(fname) do
    grid =
      File.read!("priv/#{fname}")
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, rownum} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {cell, colnum} -> {{rownum, colnum}, cell} end)
      end)
      |> Map.new()

    {start_pos, _} = Enum.find(grid, fn {_, cell} -> cell == "^" end)

    {start_pos, grid}
  end
end
