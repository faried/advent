defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  @test_input Day14.read_input("test.txt")
  @real_input Day14.read_input("14.txt")

  test "part 1 sample" do
    assert Day14.part1(@test_input) == 24
  end

  test "part 1" do
    assert Day14.part1(@real_input) == 592
  end

  test "part 2 sample" do
    assert Day14.part2(@test_input) == 93
  end

  test "part 2" do
    assert Day14.part2(@real_input) == 30_367
  end
end
