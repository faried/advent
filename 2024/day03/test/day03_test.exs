defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  @real_input Day03.read_input("3.txt")
  @test_input1 Day03.read_input("test1.txt")
  @test_input2 Day03.read_input("test2.txt")

  test "part 1 sample" do
    assert Day03.part1(@test_input1) == 161
  end

  test "part 1" do
    assert Day03.part1(@real_input) == 188_741_603
  end

  test "part 2 sample" do
    assert Day03.part2(@test_input2) == 48
  end

  test "part 2" do
    assert Day03.part2(@real_input) == 67_269_798
  end
end
