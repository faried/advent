defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  @test_input [
    "vJrwpWtwJgWrhcsFMMfFFhFp",
    "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
    "PmmdzqPrVvPwwTWBwg",
    "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
    "ttgJtRGJQctTZtZT",
    "CrZsJsPPZsGzwwsLwLmpwMDw"
  ]
  @real_input Day03.read_input("3.txt")

  test "part 1 sample" do
    assert Day03.part1(@test_input) == 157
  end

  test "part 1" do
    assert Day03.part1(@real_input) == 7826
  end

  test "part 2 sample" do
    assert Day03.part2(@test_input) == 70
  end

  test "part 2" do
    assert Day03.part2(@real_input) == 2577
  end
end
