defmodule Day09Test do
  use ExUnit.Case
  doctest Day09

  @test_input ~s"""
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  """

  test "part 1 sample" do
    input = to_array(@test_input)
    assert Day09.part1(input) == 15
  end

  test "part 1" do
    input =
      read_input()
      |> to_array()

    assert Day09.part1(input) == 541
  end

  test "part 2 sample" do
    input = to_array(@test_input)
    assert Day09.part2(input) == 1134
  end

  test "part 2" do
    input =
      read_input()
      |> to_array()

    assert Day09.part2(input) == 847_504
  end

  defp to_array(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp read_input() do
    File.read!("9.txt")
  end
end
