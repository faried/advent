defmodule Day03 do
  @digits 0..9 |> Enum.map(&Integer.to_string/1)

  def part1(input) do
    # loop over parts, find ones with symbols next to them
    parts = Enum.flat_map(input, &find_parts/1)

    symbols =
      Enum.flat_map(input, &find_symbols/1)
      |> Map.new()

    parts
    |> Enum.map(&around/1)
    |> Enum.reduce([], fn {part, positions}, acc ->
      if symaround?(positions, symbols), do: [String.to_integer(part) | acc], else: acc
    end)
    |> Enum.sum()
  end

  def part2(input) do
    # loop over gear symbols, find parts next to them
    grid = to_grid(input)

    parts = Enum.flat_map(input, &find_parts/1)

    gears =
      input
      |> Enum.flat_map(&find_symbols/1)
      |> Enum.reduce([], fn {pos, symbol}, acc ->
        if symbol == "*", do: [pos | acc], else: acc
      end)

    # for each possible gear, it finds the positions of digits
    # adjacent to it on the grid (if any).  for each position, it
    # finds the part that digit belongs to
    gears
    |> Enum.map(fn pos ->
      find_nearby_parts(pos, grid)
      |> Enum.flat_map(&part_number(parts, &1))
      |> MapSet.new()
      # if there are two parts, we're looking at a gear; calculate gear ratio
      |> then(fn part_numbers ->
        if MapSet.size(part_numbers) == 2, do: Enum.product(part_numbers), else: 0
      end)
    end)
    |> Enum.sum()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> to_rows()
  end

  defp to_rows(input) do
    input
    |> Enum.with_index()
  end

  defp to_grid(input) do
    Enum.flat_map(input, fn {row, row_num} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {thing, col_num} ->
        {{row_num, col_num}, thing}
      end)
    end)
    |> Map.new()
  end

  defp find_parts({row, row_num}) do
    # this adds an empty position after the last column.  it's a hack
    # to let the reduce function below find part numbers that are
    # located at the right edge of the row.
    (row <> ".")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce({[], ""}, fn {thing, col_num}, {acc, prev} ->
      if thing in @digits do
        {acc, prev <> thing}
      else
        # were we in the process of collecting a part number?
        if prev != "" do
          {[{prev, {row_num, col_num - String.length(prev)}} | acc], ""}
        else
          {acc, prev}
        end
      end
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp find_symbols({row, row_num}) do
    row
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce([], fn {thing, col_num}, acc ->
      if thing not in @digits and thing != "." do
        [{{row_num, col_num}, thing} | acc]
      else
        acc
      end
    end)
  end

  defp adjacents({r, c}) do
    for(y <- (r - 1)..(r + 1), x <- (c - 1)..(c + 1), {y, x} != {r, c}, do: {y, x})
    |> Enum.filter(fn {y, x} -> y >= 0 and x >= 0 end)
  end

  defp find_nearby_parts(symbol_pos, grid) do
    symbol_pos
    |> adjacents()
    |> Enum.filter(fn pos -> grid[pos] in @digits end)
  end

  defp part_number(pns, {r, c}) do
    Enum.reduce(pns, [], fn {thing, {pr, pc}}, acc ->
      len = String.length(thing) - 1
      if pr == r and c in pc..(pc + len), do: [thing | acc], else: acc
    end)
    |> Enum.map(&String.to_integer/1)
  end

  defp around({pn, {r, c}}) do
    # map:
    #
    # ..234..
    # .......
    #
    # input: {"234", {0, 2}}
    # returns [{0, 1}, {0, 5},
    #          {1, 1}, {1, 2}, {1, 3}, {1, 4}, {1, 5}]

    len = String.length(pn) - 1
    part = Enum.map(c..(c + len), fn c -> {r, c} end)

    positions =
      part
      |> Enum.flat_map(&adjacents/1)
      |> MapSet.new()
      |> Enum.filter(fn {y, x} = pos ->
        pos not in part and y >= 0 and x >= 0
      end)

    {pn, positions}
  end

  defp symaround?(part_positions, symbols) do
    Enum.any?(part_positions, fn position -> Map.has_key?(symbols, position) end)
  end
end
