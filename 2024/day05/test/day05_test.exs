defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  @real_input Day05.read_input("5.txt")
  @test_input Day05.read_input("test.txt")

  test "part 1 sample" do
    assert Day05.part1(@test_input) == 143
  end

  test "part 1" do
    assert Day05.part1(@real_input) == 4996
  end

  test "part 2 sample" do
    assert Day05.part2(@test_input) == 123
  end

  test "part 2" do
    assert Day05.part2(@real_input) == 6311
  end
end
