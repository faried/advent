defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  @test_input Day07.read_input("test.txt")
  @real_input Day07.read_input("7.txt")

  test "part 1 sample" do
    assert Day07.part1(@test_input) == 95437
  end

  test "part 1" do
    assert Day07.part1(@real_input) == 1_477_771
  end

  test "part 2 sample" do
    assert Day07.part2(@test_input) == 24_933_642
  end

  test "part 2" do
    assert Day07.part2(@real_input) == 3_579_501
  end
end
