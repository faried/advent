defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  @test_input Day05.read_input("test.txt")
  @real_input Day05.read_input("5.txt")

  test "part 1 sample" do
    assert Day05.part1(@test_input) == "CMZ"
  end

  test "part 1" do
    assert Day05.part1(@real_input) == "GRTSWNJHH"
  end

  test "part 2 sample" do
    assert Day05.part2(@test_input) == "MCD"
  end

  test "part 2" do
    assert Day05.part2(@real_input) == "QLFQDBBHM"
  end
end
