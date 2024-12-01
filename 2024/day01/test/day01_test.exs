defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @real_input Day01.read_input("1.txt")
  @test_input Day01.read_input("test.txt")

  test "part 1 sample" do
    assert Day01.part1(@test_input) == 11
  end

  test "part 1" do
    assert Day01.part1(@real_input) == 2_000_468
  end

  test "part 2 sample" do
    assert Day01.part2(@test_input) == 31
  end

  test "part 2" do
    assert Day01.part2(@real_input) == 18_567_089
  end
end
