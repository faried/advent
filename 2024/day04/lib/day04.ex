defmodule Day04 do
  @moduledoc """
  Documentation for `Day04`.
  """

  def part1(input) do
    left_right = scan(input)

    grid = to_grid(input)
    rotated = rotate(grid)

    up_down = scan(rotated)

    left_right + up_down + diagonals(grid)
  end

  def part2(input) do
    input
    |> to_grid()
    |> diagonals2()
  end

  def scan(input) do
    Enum.reduce(input, 0, fn line, acc ->
      acc +
        Enum.count(Regex.scan(~r/XMAS/, line)) +
        Enum.count(Regex.scan(~r/SAMX/, line))
    end)
  end

  def to_grid(lines) do
    Enum.with_index(lines)
    |> Enum.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.map(fn {letter, col} -> {{row, col}, letter} end)
    end)
    |> Map.new()
  end

  def rotate(grid) do
    max_rows = Map.keys(grid) |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_cols = Map.keys(grid) |> Enum.map(&elem(&1, 1)) |> Enum.max()

    Enum.reduce(0..max_cols, [], fn col, acc ->
      new_line =
        Enum.map_join(0..max_rows, "", fn row ->
          grid[{row, col}]
        end)

      [new_line | acc]
    end)
    |> Enum.reverse()
  end

  def diagonals(grid) do
    Enum.reduce(grid, 0, fn {{r, c}, val}, acc ->
      case val do
        "X" ->
          maybe =
            [
              [
                Map.get(grid, {r + 1, c + 1}, ""),
                Map.get(grid, {r + 2, c + 2}, ""),
                Map.get(grid, {r + 3, c + 3}, "")
              ]
              |> Enum.join(""),
              [
                Map.get(grid, {r - 1, c + 1}, ""),
                Map.get(grid, {r - 2, c + 2}, ""),
                Map.get(grid, {r - 3, c + 3}, "")
              ]
              |> Enum.join(""),
              [
                Map.get(grid, {r + 1, c - 1}, ""),
                Map.get(grid, {r + 2, c - 2}, ""),
                Map.get(grid, {r + 3, c - 3}, "")
              ]
              |> Enum.join(""),
              [
                Map.get(grid, {r - 1, c - 1}, ""),
                Map.get(grid, {r - 2, c - 2}, ""),
                Map.get(grid, {r - 3, c - 3}, "")
              ]
              |> Enum.join("")
            ]

          acc + Enum.count(maybe, fn m -> m == "MAS" end)

        _ ->
          acc
      end
    end)
  end

  def diagonals2(grid) do
    Enum.reduce(grid, 0, fn {{r, c}, val}, acc ->
      case val do
        "A" ->
          maybe =
            [
              Map.get(grid, {r - 1, c - 1}, ""),
              Map.get(grid, {r - 1, c + 1}, ""),
              Map.get(grid, {r + 1, c - 1}, ""),
              Map.get(grid, {r + 1, c + 1}, "")
            ]
            |> Enum.join("")

          if maybe in ["MSMS", "SMSM", "MMSS", "SSMM"], do: acc + 1, else: acc

        _ ->
          acc
      end
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end
end
