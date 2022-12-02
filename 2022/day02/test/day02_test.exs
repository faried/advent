defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  @test_input [["A", "Y"], ["B", "X"], ["C", "Z"]]
  @real_input Day02.read_input("2.txt")

  test "part 1 sample" do
    assert Day02.part1(@test_input) == 15
  end

  test "part 1" do
    assert Day02.part1(@real_input) == 10994
  end

  test "part 2 sample" do
    assert Day02.part2(@test_input) == 12
  end

  test "part 2" do
    assert Day02.part2(@real_input) == 12526
  end
end
