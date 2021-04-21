defmodule Day03.Forest do
  defstruct forest: [], width: 0, height: 0
end

defmodule Day03 do
  alias Day03.Forest

  def readinput() do
    input =
      File.stream!("3.input.txt")
      |> Enum.map(fn line -> String.trim(line) |> String.graphemes() end)

    %Forest{forest: input, height: length(input), width: length(Enum.at(input, 0))}
  end

  def part1(forest \\ readinput()) do
    move(forest, 3, 1, 0, 0, 0)
  end

  def part2(forest \\ readinput()) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right, down} ->
      move(forest, right, down, 0, 0, 0)
    end)
    |> Enum.reduce(1, &*/2)
  end

  def move(forest, right, down, x, y, numtrees) do
    newx = rem(x + right, forest.width)
    newy = y + down

    if newy >= forest.height do
      numtrees + under(forest, x, y)
    else
      move(forest, right, down, newx, newy, numtrees + under(forest, x, y))
    end
  end

  def under(forest, x, y) do
    if Enum.at(forest.forest, y) |> Enum.at(x) == "#", do: 1, else: 0
  end
end
