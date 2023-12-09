defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  @real_input Day07.read_input("7.txt")
  @test_input Day07.read_input("test.txt")

  test "part 1 sample" do
    assert Day07.part1(@test_input) == 6440
  end

  test "part 1" do
    assert Day07.part1(@real_input) == 250_951_660
  end

  test "part 2 sample" do
    assert Day07.part2(@test_input) == 5905
  end

  test "part 2" do
    assert Day07.part2(@real_input) == 251_481_660
  end
end
