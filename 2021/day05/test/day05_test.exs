defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  @test_input [
    "0,9 -> 5,9",
    "8,0 -> 0,8",
    "9,4 -> 3,4",
    "2,2 -> 2,1",
    "7,0 -> 7,4",
    "6,4 -> 2,0",
    "0,9 -> 2,9",
    "3,4 -> 1,4",
    "0,0 -> 8,8",
    "5,5 -> 8,2"
  ]

  test "part 1 sample" do
    assert Day05.part1(@test_input) == 5
  end

  test "part 1" do
    input = read_input()
    assert Day05.part1(input) == 5373
  end

  test "part 2 sample" do
    assert Day05.part2(@test_input) == 12
  end

  test "part 2" do
    input = read_input()
    assert Day05.part2(input) == 21514
  end

  defp read_input() do
    File.read!("5.txt")
    |> String.trim()
    |> String.split("\n")
  end
end
