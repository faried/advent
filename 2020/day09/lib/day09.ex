defmodule Day09.Window do
  defstruct numbers: [], revmap: nil

  def new(ls) do
    %__MODULE__{
      numbers: ls,
      revmap: MapSet.new(for x <- ls, y <- ls, x < y, do: x + y)
    }
  end

  def add(window, num) do
    if num in window.revmap do
      {_, rest} = List.pop_at(window.numbers, 0)
      {:ok, new(rest ++ [num])}
    else
      {:error, num}
    end
  end
end

defmodule Day09 do
  alias Day09.Window

  @preamble 25

  def readinput() do
    File.read!("9.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input \\ readinput()) do
    preamble =
      input
      |> Enum.take(@preamble)
      |> Window.new()

    loop(Enum.drop(input, @preamble), preamble)
  end

  def loop([head | rest], preamble) do
    case Window.add(preamble, head) do
      {:ok, newpreamble} -> loop(rest, newpreamble)
      {:error, num} -> num
    end
  end

  def part2(input \\ readinput()) do
    badval = part1()
    find(input, badval)
  end

  def find(input, badval) do
    case addupto(input, badval) do
      {:ok, run} -> weakness(Enum.take(input, run) |> Enum.sort())
      {:error, _} -> find(tl(input), badval)
    end
  end

  def addupto([head | tail], badval, total \\ 0, idx \\ 0) do
    cond do
      total + head == badval -> {:ok, idx - 1}
      total + head > badval -> {:error, idx}
      true -> addupto(tail, badval, total + head, idx + 1)
    end
  end

  def weakness(sorted), do: List.first(sorted) + List.last(sorted)
end
