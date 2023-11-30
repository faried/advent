defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  @test_input Day25.read_input("test.txt")
  @real_input Day25.read_input("25.txt")

  test "part 1 sample" do
    assert Day25.part1(@test_input) == "2=-1=0"
  end

  test "part 1" do
    assert Day25.part1(@real_input) == "2-==10--=-0101==1201"
  end
end
