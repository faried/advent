defmodule Day09Test do
  use ExUnit.Case
  doctest Day09

  @test_input Day09.read_input("test.txt")
  @test_input2 Day09.read_input("test2.txt")
  @real_input Day09.read_input("9.txt")

  test "part 1 sample" do
    assert Day09.part1(@test_input) == 13
  end

  test "part 1" do
    assert Day09.part1(@real_input) == 5619
  end

  test "part 2 sample" do
    assert Day09.part2(@test_input) == 1
    assert Day09.part2(@test_input2) == 36
  end

  test "part 2" do
    assert Day09.part2(@real_input) == 2376
  end
end
