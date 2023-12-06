defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  @real_input Day06.read_input("6.txt")
  @test_input Day06.read_input("test.txt")

  test "part 1 sample" do
    assert Day06.part1(@test_input) == 288
  end

  test "part 1" do
    assert Day06.part1(@real_input) == 220_320
  end

  test "part 2 sample" do
    assert Day06.part2(@test_input) == 71503
  end

  test "part 2" do
    assert Day06.part2(@real_input) == 34_454_850
  end
end
