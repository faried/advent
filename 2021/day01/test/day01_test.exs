defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @test_input [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]

  test "part 1 sample" do
    assert Day01.part1(@test_input) == 7
  end

  test "part 1" do
    input = read_input("1.txt")
    assert Day01.part1(input) == 1624
  end

  test "part 2 sample" do
    assert Day01.part2(@test_input) == 5
  end

  test "part 2" do
    input = read_input("1.txt")
    assert Day01.part2(input) == 1653
  end

  defp read_input(fname) do
    File.stream!(fname)
    |> Enum.map(fn line -> String.trim(line) |> String.to_integer() end)
  end

end
