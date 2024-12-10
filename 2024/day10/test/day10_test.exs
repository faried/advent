defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  @real_input Day10.read_input("10.txt")
  @test_input1 Day10.read_input("test.txt")
  @test_input2 Day10.read_input("test2.txt")
  @test_input3 Day10.read_input("test3.txt")
  @test_input4 Day10.read_input("test4.txt")
  @test_input5 Day10.read_input("test5.txt")
  # part 2
  @test_input6 Day10.read_input("test6.txt")
  @test_input7 Day10.read_input("test7.txt")

  test "part 1 sample" do
    assert Day10.part1(@test_input1) == 1
    assert Day10.part1(@test_input2) == 2
    assert Day10.part1(@test_input3) == 4
    assert Day10.part1(@test_input4) == 3
    assert Day10.part1(@test_input5) == 36
  end

  test "part 1" do
    assert Day10.part1(@real_input) == 548
  end

  test "part 2 sample" do
    assert Day10.part2(@test_input5) == 81
    assert Day10.part2(@test_input6) == 3
    assert Day10.part2(@test_input7) == 13
  end

  test "part 2" do
    assert Day10.part2(@real_input) == 1252
  end
end
