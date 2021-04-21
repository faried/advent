defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "split it properly" do
    parts = Day02.split("3-4 c: cccc")
    assert Enum.at(parts, 0) == [3, 4]
    assert Enum.at(parts, 1) == "c"
    assert Enum.at(parts, 2) == "cccc"
  end

  test "good password (part 1)" do
    assert Day02.part1([[[1, 4], "s", "ssss"]]) == 1
  end

  test "good password (part 2)" do
    assert Day02.part2([[[1, 4], "s", "ssab"]]) == 1
  end
end
