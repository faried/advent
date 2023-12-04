defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  @real_input Day04.read_input("4.txt")
  @test_input Day04.read_input("test.txt")

  test "part 1 sample" do
    assert Day04.part1(@test_input) == 13
  end

  test "part 1" do
    assert Day04.part1(@real_input) == 26914
  end

  test "part 2 sample" do
    assert Day04.part2(@test_input) == 30
  end

  test "part 2" do
    assert Day04.part2(@real_input) == 13_080_971
  end
end
