defmodule Day05 do
  def readinput() do
    File.read!("5.input.txt")
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  def part1(input \\ readinput()) do
    input
    |> Enum.map(&findseat/1)
    |> Enum.max()
  end

  def part2(input \\ readinput()) do
    ids =
      input
      |> Enum.map(&findseat/1)
      |> Enum.sort()

    findmissing(MapSet.new(ids), List.first(ids), List.last(ids))
  end

  def findmissing(_mids, curid, maxid) when curid > maxid, do: :error

  def findmissing(mids, curid, maxid) do
    if curid not in mids and (curid - 1) in mids and (curid + 1) in mids do
      curid
    else
      findmissing(mids, curid + 1, maxid)
    end
  end

  def findseat(assignment, row \\ 0..127, col \\ 0..7)

  def findseat([], row, col), do: row.first * 8 + col.first

  # just makes writing the test cases easier
  def findseat(assignment, row, col) when is_binary(assignment),
    do: findseat(String.graphemes(assignment), row, col)

  def findseat([letter | assignment], row, col) do
    case letter do
      "F" -> findseat(assignment, lower(row), col)
      "B" -> findseat(assignment, upper(row), col)
      "R" -> findseat(assignment, row, upper(col))
      "L" -> findseat(assignment, row, lower(col))
    end
  end

  def lower(range) do
    range.first..(range.first + div(range.last - range.first, 2))
  end

  def upper(range) do
    (range.first + div(1 + range.last - range.first, 2))..range.last
  end
end
