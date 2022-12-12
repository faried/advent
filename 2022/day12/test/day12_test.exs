defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  @test_input Day12.read_input("test.txt")
  @real_input Day12.read_input("12.txt")

  test "part 1 sample" do
    assert Day12.part1(@test_input) == 31
  end

  test "part 1" do
    assert Day12.part1(@real_input) == 520
  end

  test "part 2 sample" do
    assert Day12.part2(@test_input) == 29
  end

  test "part 2" do
    assert Day12.part2(@real_input) == 508
  end
end
