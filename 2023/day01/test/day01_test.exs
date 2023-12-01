defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @real_input Day01.read_input("1.txt")
  @test_input1 Day01.read_input("test1.txt")
  @test_input2 Day01.read_input("test2.txt")

  test "part 1 sample" do
    assert Day01.part1(@test_input1) == 142
  end

  test "part 1" do
    assert Day01.part1(@real_input) == 55712
  end

  test "part 2 sample" do
    assert Day01.part2(@test_input1) == 142
    assert Day01.part2(@test_input2) == 281
  end

  test "part 2" do
    assert Day01.part2(@real_input) == 55413
  end
end
