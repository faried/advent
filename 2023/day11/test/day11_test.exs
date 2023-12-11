defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  @real_input Day11.read_input("11.txt")
  @test_input Day11.read_input("test.txt")

  test "part 1 sample" do
    assert Day11.part1(@test_input) == 374
  end

  test "part 1" do
    assert Day11.part1(@real_input) == 9_521_776
  end

  test "part 2 sample" do
    assert Day11.part2(@test_input, 10) == 1030
  end

  test "part 2" do
    assert Day11.part2(@real_input, 1_000_000) == 553_224_415_344
  end
end
