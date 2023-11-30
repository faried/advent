defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  @test_input Day21.read_input("test.txt")
  @real_input Day21.read_input("21.txt")

  test "part 1 sample" do
    assert Day21.part1(@test_input) == 152
  end

  test "part 1" do
    assert Day21.part1(@real_input) == 62386792426088
  end

  test "part 2 sample" do
    assert Day21.part2(@test_input) == :ok
    end

  test "part 2" do
    assert Day21.part2(@real_input) == :ok
  end
end
