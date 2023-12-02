defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  @real_input Day02.read_input("2.txt")
  @test_input Day02.read_input("test.txt")

  test "part 1 sample" do
    assert Day02.part1(@test_input) == 8
  end

  test "part 1" do
    assert Day02.part1(@real_input) == 2061
  end

  test "part 2 sample" do
    assert Day02.part2(@test_input) == 2286
  end

  test "part 2" do
    assert Day02.part2(@real_input) == 72596
  end
end
