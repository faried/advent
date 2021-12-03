defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  @test_input [
    "00100",
    "11110",
    "10110",
    "10111",
    "10101",
    "01111",
    "00111",
    "11100",
    "10000",
    "11001",
    "00010",
    "01010"
  ]

  test "part 1 sample" do
    assert Day03.part1(@test_input) == 198
  end

  test "part 1" do
    input = read_input("3.txt")
    assert Day03.part1(input) == 4_103_154
  end

  test "part 2 sample" do
    assert Day03.part2(@test_input) == 230
  end

  test "part 2" do
    input = read_input("3.txt")
    assert Day03.part2(input) == 4_245_351
  end

  defp read_input(fname) do
    File.stream!(fname)
    |> Enum.map(&String.trim/1)
  end
end
