defmodule Day11.Grid do
  @empty "L"
  @occupied "#"
  @space "."
  @seats [@empty, @occupied]

  def seat?(row, col, grid), do: Map.get(grid, {row, col}) in @seats

  def move(-1, _col, _delta, _area), do: {-1, -1}
  def move(_row, -1, _delta, _area), do: {-1, -1}

  def move(row, _col, _delta, {numrows, _, _}) when row == numrows, do: {-1, -1}
  def move(_row, col, _delta, {_, numcols, _}) when col == numcols, do: {-1, -1}

  def move(row, col, {dx, dy} = delta, {_, _, grid} = area) do
    newrow = row + dx
    newcol = col + dy

    if seat?(newrow, newcol, grid), do: {newrow, newcol}, else: move(newrow, newcol, delta, area)
  end

  def dirs(row, col, _area, 1 = _part) do
    [
      {row, col - 1},
      {row, col + 1},
      {row - 1, col},
      {row + 1, col},
      {row - 1, col - 1},
      {row - 1, col + 1},
      {row + 1, col - 1},
      {row + 1, col + 1}
    ]
  end

  def dirs(row, col, area, 2 = _part) do
    [
      move(row, col, {0, -1}, area),
      move(row, col, {0, 1}, area),
      move(row, col, {-1, 0}, area),
      move(row, col, {1, 0}, area),
      move(row, col, {-1, -1}, area),
      move(row, col, {-1, 1}, area),
      move(row, col, {1, -1}, area),
      move(row, col, {1, 1}, area)
    ]
  end

  def occupiedaround(row, col, {numrows, numcols, grid} = area, part) do
    dirs(row, col, area, part)
    |> Enum.count(fn {r, c} ->
      r in 0..(numrows - 1) and c in 0..(numcols - 1) and Map.get(grid, {r, c}) == @occupied
    end)
  end

  def change({r, c, @space}, _area, _part), do: {{r, c}, @space}

  def change({r, c, @empty}, area, part) do
    countoccupied = occupiedaround(r, c, area, part)
    {{r, c}, if(countoccupied == 0, do: @occupied, else: @empty)}
  end

  def change({r, c, @occupied}, area, part) do
    countoccupied = occupiedaround(r, c, area, part)

    maxfree = if part == 1, do: 3, else: 4

    {{r, c}, if(countoccupied > maxfree, do: @empty, else: @occupied)}
  end

  def step({numrows, numcols, grid} = area, part) do
    newgrid =
      for col <- 0..(numcols - 1),
          row <- 0..(numrows - 1) do
        change({row, col, Map.get(grid, {row, col})}, area, part)
      end
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, v) end)

    {numrows, numcols, newgrid}
  end

  def countoccupied({numrows, numcols, grid}) do
    for(
      col <- 0..(numcols - 1),
      row <- 0..(numrows - 1),
      do: Map.get(grid, {row, col}) == @occupied
    )
    |> Enum.count(& &1)
  end

  def printarea({numrows, numcols, grid} = area) do
    for(col <- 0..(numcols - 1), row <- 0..(numrows - 1), do: Map.get(grid, {row, col}))
    |> Enum.chunk_every(numrows)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.join("\n")
    |> IO.puts()

    area
  end
end

defmodule Day11 do
  alias Day11.Grid

  def readinput() do
    rows =
      File.read!("11.test.txt")
      |> String.split("\n", trim: true)

    numrows = length(rows)
    numcols = String.length(Enum.at(rows, 0))

    grid =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(fn {rowstr, rownum} ->
        String.graphemes(rowstr)
        |> Enum.with_index()
        |> Enum.flat_map(fn {letter, colnum} -> %{{rownum, colnum} => letter} end)
      end)
      |> Enum.into(%{})

    {numrows, numcols, grid}
  end

  def untilstable(area, occupied, part) do
    newarea = Grid.step(area, part)
    newoccupied = Grid.countoccupied(newarea)

    if newoccupied == occupied, do: newoccupied, else: untilstable(newarea, newoccupied, part)
  end

  def part1(area \\ readinput()) do
    untilstable(area, Grid.countoccupied(area), 1)
  end

  def part2(area \\ readinput()) do
    untilstable(area, Grid.countoccupied(area), 2)
  end
end
