defmodule Day08 do
  @moduledoc """
  Documentation for `Day08`.
  """

  @antenna [?0..?9, ?a..?z, ?A..?Z]

  def part1(grid) do
    find_antinodes(grid)
    |> Enum.count()
  end

  def part2(grid) do
    find_antinodes2(grid)
    |> Enum.count()
  end

  def find_antennas(grid) do
    grid
    |> Enum.reduce(Map.new(), fn {pos, cell}, acc ->
      cond do
        cell == "." ->
          acc

        antenna?(cell) ->
          Map.update(acc, cell, [pos], fn e -> [pos | e] end)

        true ->
          acc
      end
    end)
  end

  def find_antinodes(grid) do
    antennas = find_antennas(grid)

    Enum.flat_map(antennas, fn {antenna, positions} ->
      for(p1 <- positions, p2 <- positions, p1 != p2, do: [p1, p2])
      |> Enum.flat_map(fn [{ar, ac}, {br, bc}] ->
        dr = ar - br
        dc = ac - bc
        [{ar + dr, ac + dc}, {br + dr, bc + dc}]
      end)
      |> Enum.reject(fn pos ->
        maybe = Map.get(grid, pos)
        # we count antinodes that overlap with other antennas
        # but not the same ones we're considering
        is_nil(maybe) or maybe == antenna
      end)
    end)
    |> MapSet.new()
  end

  def find_antinodes2(grid) do
    antennas = find_antennas(grid)

    Enum.flat_map(antennas, fn {_antenna, positions} ->
      for(p1 <- positions, p2 <- positions, p1 != p2, do: [p1, p2])
      |> Enum.flat_map(fn [{ar, ac} = p1, {br, bc} = p2] ->
        delta = {ar - br, ac - bc}

        extend(p1, delta, grid) ++ extend(p2, delta, grid)
      end)
      |> Enum.filter(&Map.has_key?(grid, &1))
    end)
    |> MapSet.new()
  end

  def extend(pos, {dr, dc}, grid) do
    Stream.iterate(pos, fn {r, c} -> {r + dr, c + dc} end)
    |> Enum.take_while(&Map.has_key?(grid, &1))
  end

  def antenna?(cell) do
    cellchar =
      cell
      |> String.to_charlist()
      |> hd()

    Enum.any?(@antenna, fn range -> cellchar in range end)
  end

  def to_grid(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, rownum} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {cell, colnum} ->
        {{rownum, colnum}, cell}
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
