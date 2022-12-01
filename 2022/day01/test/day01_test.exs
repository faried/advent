defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  @test_input [[1000, 2000, 3000], [4000], [5000, 6000], [7000, 8000, 9000], [10000]]

  test "part 1 sample" do
    assert Day01.part1(@test_input) == 24000
  end

  test "part 1" do
    input = read_input("1.txt")
    assert Day01.part1(input) == 68787
  end

  test "part 2 sample" do
    assert Day01.part2(@test_input) == 45000
  end

  test "part 2" do
    input = read_input("1.txt")
    assert Day01.part2(input) == 198_041
  end

  defp read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n\n")
    |> Enum.map(fn elfcals ->
      String.split(elfcals, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
