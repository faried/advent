defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  @test_fname "4.test"
  @input_fname "4.txt"

  test "part 1 sample" do
    input = read_input(@test_fname)
    assert List.first(Day04.bingo(input)) == 4512
  end

  test "part 1" do
    input = read_input(@input_fname)
    assert List.first(Day04.bingo(input)) == 23177
  end

  test "part 2 sample" do
    input = read_input(@test_fname)
    assert List.last(Day04.bingo(input)) == 1924
  end

  test "part 2" do
    input = read_input(@input_fname)
    assert List.last(Day04.bingo(input)) == 6804
  end

  defp read_input(fname) do
    {drawstr, boards} =
      File.read!(fname)
      |> String.split("\n\n")
      |> List.pop_at(0)

    draws =
      String.split(drawstr, ",")
      |> Enum.map(&String.to_integer/1)

    intboards =
      for board <- boards,
          do: String.split(board) |> Enum.map(&String.to_integer/1) |> Enum.chunk_every(5)

    {draws, intboards}
  end
end
