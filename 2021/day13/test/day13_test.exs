defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  @test_input ~s"""
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0

  fold along y=7
  fold along x=5
  """

  test "part 1 sample" do
    assert Day13.part1(@test_input) == 17
  end

  test "part 1" do
    input = read_input()
    assert Day13.part1(input) == 695
  end

  test "part 2 sample" do
    Day13.part2(@test_input)
  end

  test "part 2" do
    input = read_input()
    Day13.part2(input)
  end

  defp read_input() do
    File.read!("13.txt")
    |> String.trim()
  end
end
