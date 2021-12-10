defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

  @pairs %{"(" => ")", "[" => "]", "{" => "}", "<" => ">"}
  @opening Map.keys(@pairs)

  @score1 %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  @score2 %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def part1(input) do
    process(input)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def part2(input) do
    scores =
      process(input)
      |> Enum.filter(fn {score, _stack} -> score == 0 end)
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(fn stack ->
        Enum.map(stack, fn o -> @pairs[o] end)
      end)
      |> Enum.map(&score2/1)
      |> Enum.sort()

    mid = div(Enum.count(scores), 2)
    Enum.at(scores, mid)
  end

  defp process(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&find_incorrect(&1, []))
  end

  defp find_incorrect([], stack), do: {0, stack}

  defp find_incorrect([paren | parens], []), do: find_incorrect(parens, [paren])

  defp find_incorrect([paren | parens], [top | rest] = stack) do
    if paren in @opening do
      find_incorrect(parens, [paren | stack])
    else
      if paren != @pairs[top] do
        # not the expected paren
        {@score1[paren], stack}
      else
        find_incorrect(parens, rest)
      end
    end
  end

  defp score2(parens), do: score2(parens, 0)

  defp score2([], total), do: total

  defp score2([paren | parens], total) do
    score2(parens, total * 5 + @score2[paren])
  end
end
