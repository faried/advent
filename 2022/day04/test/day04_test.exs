defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  @test_input Day04.read_input("test.txt")
  @real_input Day04.read_input("4.txt")

  test "part 1 sample" do
    assert Day04.part1(@test_input) == 2
  end

  test "part 1" do
    assert Day04.part1(@real_input) == 524
  end

  test "part 2 sample" do
    assert Day04.part2(@test_input) == 4
  end

  test "part 2" do
    assert Day04.part2(@real_input) == 798
  end
end
