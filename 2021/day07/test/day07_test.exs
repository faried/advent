defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  @test_input [16, 1, 2, 0, 4, 2, 7, 1, 2, 14]

  test "part 1 sample" do
    assert Day07.part1(@test_input) == 37
  end

  test "part 1" do
    input = read_input()
    assert Day07.part1(input) == 337_488
  end

  test "part 2 sample" do
    assert Day07.part2(@test_input) == 168
  end

  test "part 2" do
    input = read_input()
    assert Day07.part2(input) == 89_647_695
  end

  defp read_input() do
    File.read!("7.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
