defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  @real_input Day08.read_input("8.txt")
  @test_input Day08.read_input("test.txt")

  test "part 1 sample" do
    assert Day08.part1(@test_input) == 14
  end

  test "part 1" do
    assert Day08.part1(@real_input) == 369
  end

  test "part 2 sample" do
    assert Day08.part2(@test_input) == 34
  end

  test "part 2" do
    assert Day08.part2(@real_input) == 1169
  end
end
