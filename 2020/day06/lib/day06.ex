defmodule Day06 do
  def readinput() do
    File.read!("6.test.txt")
    |> String.split("\n\n")
    |> Enum.map(&String.split/1)
  end

  def part1(input \\ readinput()) do
    input
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.graphemes/1)
    # use Enum.uniq here
    |> Enum.map(&MapSet.new/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  def part2b(input \\ readinput()) do
    input
    |> Enum.map(fn group -> {length(group), Enum.join(group) |> String.graphemes()} end)
    |> Enum.map(fn {len, group} ->
      {
        len,
        # replace this bit with Enum.frequencies
        Enum.reduce(group, %{}, fn a, acc -> Map.update(acc, a, 1, fn cur -> cur + 1 end) end)
      }
    end)
    |> Enum.map(fn {len, group} -> Enum.count(Map.values(group), fn v -> v == len end) end)
    |> Enum.sum()
  end
end
