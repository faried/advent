defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  @test_input Day11.read_input("test.txt")
  @real_input Day11.read_input("11.txt")

  test "part 1 sample" do
    assert Day11.part1(@test_input) == 10_605
  end

  test "part 1" do
    assert Day11.part1(@real_input) == 54_253
  end

  test "part 2 sample" do
    assert Day11.part2(@test_input) == 2_713_310_158
  end

  test "part 2" do
    assert Day11.part2(@real_input) == 13_119_526_120
  end
end
