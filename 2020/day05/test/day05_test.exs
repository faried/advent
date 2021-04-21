defmodule Day05Test do
  use ExUnit.Case
  doctest Day05

  test "find the right seat id" do
    assert Day05.findseat("FBFBBFFRLR") == 357
    assert Day05.findseat("BFFFBBFRRR") == 567
    assert Day05.findseat("FFFBBBFRRR") == 119
    assert Day05.findseat("BBFFBBFRLL") == 820
  end

end
