defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  @test_input ["forward 5", "down 5", "forward 8", "up 3", "down 8", "forward 2"]

  test "part 1 sample" do
    assert Day02.part1(@test_input) == 150
  end

  test "part 1" do
    input = read_input("2.txt")
    assert Day02.part1(input) == 1654760
  end

  test "part 2 sample" do
    assert Day02.part2(@test_input) == 900
  end

  test "part 2" do
    input = read_input("2.txt")
    assert Day02.part2(input) == 1956047400
  end

  defp read_input(fname) do
    File.stream!(fname)
    |> Enum.map(&String.trim/1)
  end
end
