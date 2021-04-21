defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "adding two numbers is easy to do" do
    assert Day01.part1([2018, 2]) == 4036
  end

  test "part1 cannot find 2020" do
    assert Day01.part1([1010, 500, 510]) == :barf
  end

  test "adding three numbers is just as easy" do
    assert Day01.part2([1010, 500, 510]) == 257_550_000
  end

  test "part2 cannot find 2020" do
    assert Day01.part2([1010, 501, 510]) == :barf
  end

  test "part1" do
    Day01.readinput() |> Day01.part1() |> IO.puts()
  end

  test "part2" do
    Day01.readinput() |> Day01.part2() |> IO.puts()
  end
end
