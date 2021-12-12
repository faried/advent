defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  @test_input_1 ~s"""
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  """

  @test_input_2 ~s"""
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
  """

  @test_input_3 ~s"""
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  """

  test "part 1 sample 1" do
    assert Day12.part1(@test_input_1) == 10
  end

  test "part 1 sample 2" do
    assert Day12.part1(@test_input_2) == 19
  end

  test "part 1 sample 3" do
    assert Day12.part1(@test_input_3) == 226
  end

  test "part 1" do
    input = read_input()
    assert Day12.part1(input) == 3450
  end

  test "part 2 sample 1" do
    assert Day12.part2(@test_input_1) == 36
  end

  test "part 2 sample 2" do
    assert Day12.part2(@test_input_2) == 103
  end

  test "part 2 sample 3" do
    assert Day12.part2(@test_input_3) == 3509
  end

  test "part 2" do
    input = read_input()
    assert Day12.part2(input) == 96528
  end

  defp read_input do
    File.read!("12.txt") |> String.trim()
  end
end
