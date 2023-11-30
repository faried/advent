defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  @test_input Day22.read_input("test.txt")
  @real_input Day22.read_input("22.txt")

  test "part 1 sample" do
    assert Day22.part1(@test_input) == 6032
  end

  @tag :skip
  test "part 1" do
    assert Day22.part1(@real_input) == 88226
  end

  test "part 2 sample" do
    assert Day22.part2(@test_input) == 5031
  end

  @tag :skip
  test "part 2" do
    assert Day22.part2(@real_input) == nil
  end

end
