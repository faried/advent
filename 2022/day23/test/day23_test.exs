defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  @test_input Day23.read_input("test.txt")
  @real_input Day23.read_input("23.txt")

  test "part 1 sample" do
    assert Day23.part1(@test_input) == 110
  end

  test "part 1" do
    assert Day23.part1(@real_input) == 4044
  end

  test "part 2 sample" do
    assert Day23.part2(@test_input) == 20
  end

  test "part 2" do
    assert Day23.part2(@real_input) == 1116
  end
end
