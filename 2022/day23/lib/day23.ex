defmodule Day23 do
  @moduledoc """
  Documentation for `Day23`.
  """

  # positions around an elf
  @adjacent [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]

  @elf "#"
  @empty "."

  # positions to check for rounds 0, 1, 2, 3, 0, 1, ...
  # if all checked positions are empty, move in the direction of the first item
  @rules [
    # n, ne, nw -> n
    [{-1, 0}, {-1, 1}, {-1, -1}],
    # s, se, sw -> s
    [{1, 0}, {1, 1}, {1, -1}],
    # w, nw, sw -> w
    [{0, -1}, {-1, -1}, {1, -1}],
    # e, ne, se -> e
    [{0, 1}, {-1, 1}, {1, 1}]
  ]

  def part1(map) do
    Enum.reduce(0..10, map, fn r, acc ->
      do_round(acc, r)
      |> elem(1)
    end)
    |> count_ground()
  end

  def part2(map, rnum \\ 0) do
    case do_round(map, rnum) do
      {:cont, newmap} -> part2(newmap, rnum + 1)
      {:halt, rounds} -> rounds
    end
  end

  def do_round(map, rnum) do
    proposals =
      map
      |> Map.keys()
      |> Enum.map(fn pos ->
        cond do
          !adjacent_elf?(map, pos) -> {pos, pos}
          !any_elf_in_dir?(map, pos, rnum) -> move(pos, rnum)
          !any_elf_in_dir?(map, pos, rnum + 1) -> move(pos, rnum + 1)
          !any_elf_in_dir?(map, pos, rnum + 2) -> move(pos, rnum + 2)
          !any_elf_in_dir?(map, pos, rnum + 3) -> move(pos, rnum + 3)
          # can't move
          true -> {pos, pos}
        end
      end)

    if Enum.all?(proposals, fn {curpos, newpos} -> curpos == newpos end) do
      # we're done
      {:halt, rnum + 1}
    else
      newposcount =
        proposals
        |> Enum.reduce(%{}, fn {curpos, newpos}, acc ->
          if curpos != newpos, do: Map.update(acc, newpos, 1, fn e -> e + 1 end), else: acc
        end)

      newmap =
        proposals
        |> Enum.reduce(map, fn {curpos, newpos}, acc ->
          cond do
            curpos == newpos ->
              acc

            Map.get(newposcount, newpos) == 1 ->
              Map.delete(acc, curpos)
              |> Map.put(newpos, @elf)

            true ->
              acc
          end
        end)

      {:cont, newmap}
    end
  end

  defp adjacent_elf?(map, {r, c}) do
    Enum.any?(@adjacent, fn {dr, dc} -> Map.get(map, {r + dr, c + dc}) == @elf end)
  end

  defp any_elf_in_dir?(map, {r, c}, rule) do
    @rules
    |> Enum.at(rem(rule, 4))
    |> Enum.any?(fn {dr, dc} -> Map.get(map, {r + dr, c + dc}) == @elf end)
  end

  # curpos -> {curpos, newpos}
  def move({r, c}, rule) do
    {dr, dc} =
      @rules
      |> Enum.at(rem(rule, 4))
      |> hd()

    {{r, c}, {r + dr, c + dc}}
  end

  def to_map(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, rownum} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {ground, colnum} -> {{rownum, colnum}, ground} end)
    end)
    # we only care about elves
    |> Enum.filter(fn {_pos, ground} -> ground == @elf end)
    |> Map.new()
  end

  defp count_ground(map) do
    coords = Map.keys(map)

    {rmin, rmax} =
      coords
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {cmin, cmax} =
      coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    for(r <- rmin..rmax, c <- cmin..cmax, do: Map.get(map, {r, c}, @empty))
    |> Enum.count(fn ground -> ground == @empty end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> to_map()
  end
end
