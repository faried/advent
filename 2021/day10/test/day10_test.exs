defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  @test_input ~s"""
  [({(<(())[]>[[{[]{<()<>>
  [(()[<>])]({[<{<<[]>>(
  {([(<{}[<>[]}>{[]{[(<()>
  (((({<>}<{<{<>}{[]{[]{}
  [[<[([]))<([[{}[[()]]]
  [{[{({}]{}}([{[{{{}}([]
  {<[[]]>}<{[{[{[]{()[[[]
  [<(<(<(<{}))><([]([]()
  <{([([[(<>()){}]>(<<{{
  <{([{{}}[<[[[<>{}]]]>[]]
  """

  test "part 1 sample" do
    assert Day10.part1(@test_input) == 26397
  end

  test "part 1" do
    input = read_input()
    assert Day10.part1(input) == 316_851
  end

  test "part 2 sample" do
    assert Day10.part2(@test_input) == 288_957
  end

  test "part 2" do
    input = read_input()
    assert Day10.part2(input) == 2_182_912_364
  end

  defp read_input() do
    File.read!("10.txt")
    |> String.trim()
  end
end
