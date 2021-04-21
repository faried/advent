defmodule Day02 do
  def readinput() do
    File.stream!("2.input.txt")
    |> Enum.map(&split/1)
  end

  def part1(input \\ readinput()) do
    Enum.reduce(input, 0, fn row, acc -> if valid1(row), do: acc + 1, else: acc end)
  end

  def part2(input \\ readinput()) do
    Enum.reduce(input, 0, fn row, acc -> if valid2(row), do: acc + 1, else: acc end)
  end

  def split(line) do
    [[_, left, right, char, password]] = Regex.scan(~r/(\d+)-(\d+) (\w): (\w+)/, line)

    [
      [String.to_integer(left), String.to_integer(right)],
      char,
      password
    ]
  end

  def valid1([[left, right], char, password]) do
    pchar = String.to_charlist(char)
    pwdlist = String.to_charlist(password)
    range = Range.new(left, right)

    Enum.reduce(pwdlist, 0, fn char, acc -> if [char] == pchar, do: acc + 1, else: acc end) in range
  end

  def valid2([[index1, index2], char, password]) do
    at1 = String.at(password, index1 - 1) == char
    at2 = String.at(password, index2 - 1) == char

    case [at1, at2] do
      [true, false] -> true
      [false, true] -> true
      _ -> false
    end
  end

  # from https://elixirforum.com/t/advent-of-code-2020-day-2/35931/6
  # String.graphemes converts a string to a list of strings
  # Enum.count with a function argument returns a count of "true" values
  def part1a(input \\ readinput()) do
    input
    |> Enum.count(&valid1a/1)
  end

  def valid1a([[left, right], char, password]) do
    Enum.count(String.graphemes(password), fn c -> c == char end) in Range.new(left, right)
  end
end
