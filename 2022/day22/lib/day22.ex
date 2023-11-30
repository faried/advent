defmodule Day22 do
  @moduledoc """
  Documentation for `Day22`.
  """

  @path_regex ~r/(\d+)(R|L)/
  @turnmap %{r: %{r: :d, l: :u}, d: %{r: :l, l: :r}, l: %{r: :u, l: :d}, u: %{r: :r, l: :l}}
  @dirmap %{r: 0, d: 1, l: 2, u: 3}

  def part1({rawboard, rawpath}) do
    board = to_board(rawboard)
    path = to_path(rawpath)

    start = find_starting_tile(board)
    move(path, start, :r, board)
  end

  def part2({rawboard, rawpath}) do
    board = to_board(rawboard)
    path = to_path(rawpath)

    start = find_starting_tile(board)
    move(path, start, :r, board)
  end

  def move([], {row, col}, facing, _) do
    IO.puts("now at #{inspect({row, col})} facing #{@dirmap[facing]}")
    1000 * row + 4 * col + @dirmap[facing]
  end

  def move([{count, dir} | paths], pos, facing, board) do
    # IO.puts("at #{inspect(pos)}, facing #{@dirmap[facing]}")
    # IO.puts("will move #{count} then turn #{dir}")
    newpos = do_move(board, count, pos, facing)

    move(paths, newpos, @turnmap[facing][dir], board)
  end

  def do_move(board, count, {row, _col} = pos, :r) do
    line = find_tiles(board, row, nil)

    Enum.reduce(1..count, pos, fn _, {row, col} ->
      newcol = col + 1

      newcol =
        cond do
          {row, newcol} not in line ->
            maybecol =
              line
              |> hd()
              |> elem(1)

            if board[{row, maybecol}] == "#", do: col, else: maybecol

          board[{row, newcol}] == "#" ->
            col

          true ->
            newcol
        end

      {row, newcol}
    end)
  end

  def do_move(board, count, {row, _col} = pos, :l) do
    line =
      board
      |> find_tiles(row, nil)
      |> Enum.reverse()

    Enum.reduce(1..count, pos, fn _, {row, col} ->
      newcol = col - 1

      newcol =
        cond do
          {row, newcol} not in line ->
            maybecol =
              line
              |> hd()
              |> elem(1)

            if board[{row, maybecol}] == "#", do: col, else: maybecol

          board[{row, newcol}] == "#" ->
            col

          true ->
            newcol
        end

      {row, newcol}
    end)
  end

  def do_move(board, count, {_row, col} = pos, :d) do
    line = find_tiles(board, nil, col)

    Enum.reduce(1..count, pos, fn _, {row, col} ->
      newrow = row + 1

      newrow =
        cond do
          {newrow, col} not in line ->
            mayberow =
              line
              |> hd()
              |> elem(0)

            if board[{mayberow, col}] == "#", do: row, else: mayberow

          board[{newrow, col}] == "#" ->
            row

          true ->
            newrow
        end

      {newrow, col}
    end)
  end

  def do_move(board, count, {_row, col} = pos, :u) do
    line =
      board
      |> find_tiles(nil, col)
      |> Enum.reverse()

    Enum.reduce(1..count, pos, fn _, {row, col} ->
      newrow = row - 1

      newrow =
        cond do
          {newrow, col} not in line ->
            mayberow =
              line
              |> hd()
              |> elem(0)

            if board[{mayberow, col}] == "#", do: row, else: mayberow

          board[{newrow, col}] == "#" ->
            row

          true ->
            newrow
        end

      {newrow, col}
    end)
  end

  def to_board(rawboard) do
    rawboard
    |> String.split("\n", trim: true)
    |> Enum.with_index(1)
    |> Enum.flat_map(fn {line, rownum} ->
      line
      |> String.graphemes()
      |> Enum.with_index(1)
      |> Enum.map(fn {tile, colnum} ->
        {{rownum, colnum}, tile}
      end)
    end)
    |> Map.new()
  end

  def to_path(rawpath) do
    Regex.scan(@path_regex, rawpath, capture: :all_but_first)
    |> Enum.map(fn [count, dir] ->
      {String.to_integer(count), String.downcase(dir) |> String.to_atom()}
    end)
  end

  def find_tiles(board, row \\ nil, col \\ nil) do
    sorted =
      board
      |> Map.keys()
      |> Enum.sort(fn {_, c1}, {_, c2} -> c1 > c2 end)
      |> Enum.sort(fn {r1, _}, {r2, _} -> r1 < r2 end)

    sorted = if row, do: Enum.filter(sorted, fn {r, _} -> r == row end), else: sorted
    sorted = if col, do: Enum.filter(sorted, fn {_, c} -> c == col end), else: sorted

    sorted
    |> Enum.filter(fn pos -> board[pos] != " " end)
  end

  def find_starting_tile(board) do
    board
    |> Map.keys()
    |> Enum.sort(fn {_, c1}, {_, c2} -> c1 > c2 end)
    |> Enum.sort(fn {r1, _}, {r2, _} -> r1 < r2 end)
    |> Enum.find(fn pos -> board[pos] == "." end)
  end

  def draw_board(board) do
    coords = Map.keys(board)

    {xmin, xmax} =
      coords
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    ymax =
      coords
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    Enum.map_join(1..ymax, "\n", fn y ->
      Enum.reduce(xmin..xmax, [], fn x, acc ->
        [board[{y, x}] | acc]
      end)
      |> Enum.reverse()
      |> Enum.join("")
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n\n", trim: true)
    |> List.to_tuple()
  end
end
