defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  @real_input Day07.read_input("7.txt")
  @test_input Day07.read_input("test.txt")

  test "part 1 sample" do
    assert Day07.part1(@test_input) == 3749
  end

  test "part 1" do
    assert Day07.part1(@real_input) == 1_153_997_401_072
  end

  test "part 2 sample" do
    assert Day07.part2(@test_input) == 11387
  end

  test "part 2" do
    assert Day07.part2(@real_input) == 97_902_809_384_118
  end
end
