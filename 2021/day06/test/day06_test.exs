defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  @test_input [3, 4, 3, 1, 2]

  test "part 1 sample" do
    assert Day06.multiply(@test_input, 80) == 5934
  end

  test "part 1" do
    input = read_input()
    assert Day06.multiply(input, 80) == 352_151
  end

  test "part 2 sample" do
    assert Day06.multiply(@test_input, 256) == 26_984_457_539
  end

  test "part 2" do
    input = read_input()
    assert Day06.multiply(input, 256) == 1_601_616_884_019
  end

  defp read_input() do
    File.read!("6.txt")
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
