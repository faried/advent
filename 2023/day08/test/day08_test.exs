defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  @real_input Day08.read_input("8.txt")
  @test_input Day08.read_input("test1.txt")
  @test_input_2 Day08.read_input("test2.txt")
  @test_input_3 Day08.read_input("test3.txt")

  test "part 1 sample" do
    assert Day08.part1(@test_input) == 2
    assert Day08.part1(@test_input_2) == 6
  end

  test "part 1" do
    assert Day08.part1(@real_input) == 16043
  end

  test "part 2 sample" do
    assert Day08.part2(@test_input_3) == 6
  end

  test "part 2" do
    assert Day08.part2(@real_input) == 15_726_453_850_399
  end
end
