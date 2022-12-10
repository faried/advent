defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  @test_input Day10.read_input("test.txt")
  @real_input Day10.read_input("10.txt")

  test "part 1 sample" do
    assert Day10.part1(@test_input) == 13140
  end

  test "part 1" do
    assert Day10.part1(@real_input) == 14620
  end

  test "part 2 sample" do
    assert Day10.part2(@test_input) == :ok
  end

  test "part 2" do
    assert Day10.part2(@real_input) == :ok
  end
end
