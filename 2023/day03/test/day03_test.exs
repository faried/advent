defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  @real_input Day03.read_input("3.txt")
  @test_input Day03.read_input("test.txt")

  test "part 1 sample" do
    assert Day03.part1(@test_input) == 4361
  end

  test "part 1" do
    assert Day03.part1(@real_input) == 521_515
  end

  test "part 2 sample" do
    assert Day03.part2(@test_input) == 467_835
  end

  test "part 2" do
    assert Day03.part2(@real_input) == 69_527_306
  end
end
