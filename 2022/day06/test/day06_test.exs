defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  @test_input %{
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb" => [7, 19],
    "bvwbjplbgvbhsrlpgdmjqwftvncz" => [5, 23],
    "nppdvjthqldpwncqszvftbrmjlhg" => [6, 23],
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" => [10, 29],
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw" => [11, 26]
  }
  @real_input Day06.read_input("6.txt")

  test "part 1 sample" do
    Enum.map(@test_input, fn {msg, [pos, _]} ->
      assert Day06.part1(msg) == pos
    end)
  end

  test "part 1" do
    assert Day06.part1(@real_input) == 1080
  end

  test "part 2 sample" do
    Enum.map(@test_input, fn {msg, [_, pos]} ->
      assert Day06.part2(msg) == pos
    end)
  end

  test "part 2" do
    assert Day06.part2(@real_input) == 3645
  end
end
