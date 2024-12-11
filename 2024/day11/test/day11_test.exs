defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  @real_input Day11.read_input("11.txt")
  @test_input Day11.read_input("test.txt")

  test "part 1 sample" do
    assert Day11.part1(@test_input) == 55312
  end

  test "part 1" do
    assert Day11.part1(@real_input) == 172_484
  end

  test "part 2" do
    assert Day11.part2(@real_input) == 205_913_561_055_242
  end
end
