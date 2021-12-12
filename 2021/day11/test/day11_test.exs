defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  @test_input ~s"""
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
  """

  test "part 1 sample" do
    assert Day11.part1(@test_input, 10) == 204
    assert Day11.part1(@test_input, 100) == 1656
  end

  test "part 1" do
    input = read_input()
    assert Day11.part1(input, 100) == 1571
  end

  test "part 2 sample" do
    assert Day11.part2(@test_input) == 195
  end

  test "part 2" do
    input = read_input()
    assert Day11.part2(input) == 387
  end

  defp read_input() do
    File.read!("11.txt")
    |> String.trim()
  end
end
