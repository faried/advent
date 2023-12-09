defmodule Day09Test do
  use ExUnit.Case
  doctest Day09

  @real_input Day09.read_input("9.txt")
  @test_input Day09.read_input("test.txt")

  test "part 1 sample" do
    assert Day09.part1(@test_input) == 114
  end

  test "part 1" do
    assert Day09.part1(@real_input) == 1_479_011_877
  end

  test "part 2 sample" do
    assert Day09.part2(@test_input) == 2
  end

  test "part 2" do
    assert Day09.part2(@real_input) == 973
  end
end
