defmodule Day12 do
  @moduledoc """
  Documentation for `Day12`.
  """

  @letters String.graphemes("SabcdefghijklmnopqrstuvwxyzE")

  def part1(heightmap) do
    spos = findpos(heightmap, "S") |> hd()
    epos = findpos(heightmap, "E") |> hd()
    g = graph(heightmap)
    path = Graph.get_shortest_path(g, spos, epos)
    Enum.count(path) - 1
  end

  def part2(heightmap) do
    spos = findpos(heightmap, "S") |> hd()
    heightmap = Map.put(heightmap, spos, "a")
    alist = findpos(heightmap, "a")
    epos = findpos(heightmap, "E") |> hd()
    g = graph(heightmap)

    Enum.reduce(alist, map_size(heightmap), fn pos, acc ->
      path = Graph.get_shortest_path(g, pos, epos)

      if path != nil do
        distance = Enum.count(path) - 1
        if distance < acc, do: distance, else: acc
      else
        acc
      end
    end)
  end

  def adjacent(heightmap, {x, y} = pos) do
    height = Enum.find_index(@letters, fn l -> l == heightmap[pos] end)

    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn checkpos ->
      newheight = Enum.find_index(@letters, fn l -> l == heightmap[checkpos] end)
      newheight != nil and newheight < height + 2
    end)
  end

  def findpos(heightmap, thing) do
    Enum.reduce(heightmap, [], fn {pos, v}, acc ->
      if v == thing, do: [pos | acc], else: acc
    end)
  end

  def prepare(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, rownum} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {height, colnum} ->
        {{rownum, colnum}, height}
      end)
    end)
    |> Map.new()
  end

  def graph(heightmap) do
    heightmap
    |> Map.keys()
    |> Enum.sort()
    |> Enum.reduce(Graph.new(), fn pos, g ->
      neighbors = adjacent(heightmap, pos)

      Enum.reduce(neighbors, g, fn neighbor, acc ->
        Graph.add_edge(acc, pos, neighbor)
      end)
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> prepare()
  end
end
