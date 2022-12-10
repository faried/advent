defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

  def part1(input) do
    state =
      run(input)
      |> Map.new()

    for(x <- 20..220//40, do: state[x] * x)
    |> Enum.sum()
  end

  def part2(input) do
    state = run(input)

    screenmap =
      Enum.reduce(state, %{}, fn {cycle, x}, acc ->
        xpos = rem(cycle - 1, 40)
        ypos = rem(div(cycle, 40), 6)

        if xpos in [x - 1, x, x + 1] do
          Map.put(acc, {xpos, ypos}, "#")
        else
          Map.put(acc, {xpos, ypos}, ".")
        end
      end)

    Enum.map(0..6, fn y ->
      Enum.map(0..39, fn x -> screenmap[{x, y}] end)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp noop(x, cycle), do: {cycle + 1, x}

  defp addx(x, cycle, v), do: [{cycle + 2, x + v}, {cycle + 1, x}]

  defp run(input) do
    Enum.reduce(input, [{1, 1}], fn ins, ls ->
      {cycle, x} = hd(ls)

      cond do
        ins == "noop" ->
          [noop(x, cycle) | ls]

        true ->
          [_, vs] = String.split(ins, " ", parts: 2)
          addx(x, cycle, String.to_integer(vs)) ++ ls
      end
    end)
    |> Enum.reverse()
  end
end
