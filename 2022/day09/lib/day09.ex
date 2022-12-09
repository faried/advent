defmodule Day09 do
  @moduledoc """
  Documentation for `Day09`.
  """

  @dirmap %{"R" => {1, 0}, "U" => {0, 1}, "L" => {-1, 0}, "D" => {0, -1}}
  @diagmap %{ne: {1, 1}, nw: {1, -1}, se: {-1, 1}, sw: {-1, -1}}

  def part1(input) do
    head = {0, 0}
    tail = {0, 0}

    make_move(input, head, tail, MapSet.new([tail]))
  end

  def part2(input) do
    rope = List.duplicate({0, 0}, 10)
    make_move2(input, rope, MapSet.new([{0, 0}]))
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.flat_map(fn line ->
      [dir, times] = String.split(line, " ", parts: 2)

      List.duplicate(@dirmap[dir], String.to_integer(times))
    end)
  end

  defp make_move([], _head, _tail, posmap), do: MapSet.size(posmap)

  defp make_move([{dx, dy} | moves], {hx, hy}, tail, posmap) do
    head = {hx + dx, hy + dy}
    newtail = move_tail(head, tail)

    make_move(moves, head, newtail, MapSet.put(posmap, newtail))
  end

  defp make_move2([], _, posmap), do: MapSet.size(posmap)

  defp make_move2([{dx, dy} | moves], [{hx, hy} | knots], posmap) do
    head = {hx + dx, hy + dy}

    rnewknots =
      Enum.reduce(knots, {[head], head}, fn knot, {ls, prev} ->
        newknot = move_tail(prev, knot)

        {[newknot | ls], newknot}
      end)
      |> elem(0)

    newtail = hd(rnewknots)

    make_move2(moves, Enum.reverse(rnewknots), MapSet.put(posmap, newtail))
  end

  defp adjacent?({hx, hy}, {tx, ty}) do
    abs(hx - tx) <= 1 and abs(hy - ty) <= 1
  end

  defp same_row_or_col?({x, _}, {x, _}), do: true
  defp same_row_or_col?({_, y}, {_, y}), do: true
  defp same_row_or_col?(_, _), do: false

  defp diag({hx, hy}, {tx, ty}) do
    case {hx > tx, hy > ty} do
      {true, true} -> @diagmap.ne
      {true, false} -> @diagmap.nw
      {false, true} -> @diagmap.se
      {false, false} -> @diagmap.sw
    end
  end

  defp move_closer({hx, hy}, {hx, ty}) do
    if ty > hy, do: {hx, ty - 1}, else: {hx, ty + 1}
  end

  defp move_closer({hx, hy}, {tx, hy}) do
    if tx > hx, do: {tx - 1, hy}, else: {tx + 1, hy}
  end

  defp move_tail(head, {tx, ty} = tail) do
    cond do
      adjacent?(head, tail) ->
        tail

      same_row_or_col?(head, tail) ->
        move_closer(head, tail)

      true ->
        {dx, dy} = diag(head, tail)
        {tx + dx, ty + dy}
    end
  end
end
