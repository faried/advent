defmodule Day21 do
  def readinput() do
    File.read!("21.test.txt")
    |> String.split("\n", trim: true)
  end

  def part1(input \\ readinput()) do
    Enum.flat_map(input, fn s -> Regex.replace(~r/ \(contains.*/, s, "") |> String.split() end)
    |> Enum.frequencies()
  end
end
