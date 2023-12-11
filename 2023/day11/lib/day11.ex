defmodule Day11 do
  @million 1_000_000

  def part1(map) do
    {rmax, cmax} = dimensions(map)
    {rows, columns} = find_empty(map, rmax, cmax)

    map
    |> find_galaxies(rmax, cmax)
    |> comb(2)
    |> Enum.map(fn [left, right] -> taxicab(left, right, rows, columns, 1) end)
    |> Enum.sum()
  end

  def part2(map, expand \\ @million) do
    {rmax, cmax} = dimensions(map)
    {rows, columns} = find_empty(map, rmax, cmax)

    map
    |> find_galaxies(rmax, cmax)
    |> comb(2)
    |> Enum.map(fn [left, right] -> taxicab(left, right, rows, columns, expand - 1) end)
    |> Enum.sum()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> to_map()
  end

  defp to_map(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, rownum} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {space, colnum} -> {{rownum, colnum}, space} end)
    end)
    |> Map.new()
  end

  defp dimensions(map) do
    rmax =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.max()

    cmax =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.max()

    {rmax, cmax}
  end

  defp find_empty(map, rmax, cmax) do
    columns =
      Enum.reduce(0..cmax, [], fn col, acc ->
        Enum.map(0..rmax, fn row -> map[{row, col}] end)
        |> Enum.all?(fn space -> space == "." end)
        |> then(fn empty? -> if empty?, do: [col | acc], else: acc end)
      end)

    rows =
      Enum.reduce(0..rmax, [], fn row, acc ->
        Enum.map(0..cmax, fn col -> map[{row, col}] end)
        |> Enum.all?(fn space -> space == "." end)
        |> then(fn empty? -> if empty?, do: [row | acc], else: acc end)
      end)

    {rows, columns}
  end

  defp find_galaxies(map, rmax, cmax) do
    Enum.flat_map(0..rmax, fn row ->
      Enum.reduce(0..cmax, [], fn col, acc ->
        if map[{row, col}] == "#", do: [{row, col} | acc], else: acc
      end)
    end)
  end

  defp taxicab({r1, c1}, {r2, c2}, rows, columns, expansion) do
    dist = abs(r2 - r1) + abs(c2 - c1)

    rrange = if r1 > r2, do: r2..r1, else: r1..r2
    crange = if c1 > c2, do: c2..c1, else: c1..c2

    rplus =
      Enum.reduce(rows, 0, fn row, acc -> if row in rrange, do: acc + expansion, else: acc end)

    cplus =
      Enum.reduce(columns, 0, fn col, acc -> if col in crange, do: acc + expansion, else: acc end)

    dist + rplus + cplus
  end

  # helpers

  # https://stackoverflow.com/a/55894568
  defp comb(_, 0), do: [[]]
  defp comb([], _), do: []
  defp comb([h | t], m), do: for(l <- comb(t, m - 1), do: [h | l]) ++ comb(t, m)
end
