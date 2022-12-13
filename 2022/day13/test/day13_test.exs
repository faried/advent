defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  @test_input Day13.read_input("test.txt")
  @test_input2 Day13.read_input2("test.txt")
  @real_input Day13.read_input("13.txt")
  @real_input2 Day13.read_input2("13.txt")

  test "part 1 sample" do
    assert Day13.part1(@test_input) == 13
  end

  test "part 1" do
    assert Day13.part1(@real_input) == 4643
  end

  test "part 2 sample" do
    assert Day13.part2(@test_input2) == 140
  end

  test "part 2" do
    assert Day13.part2(@real_input2) == 21_614
  end
end
