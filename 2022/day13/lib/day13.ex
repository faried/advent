defmodule Day13 do
  @moduledoc """
  Documentation for `Day13`.
  """

  def part1(input) do
    input
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{left, right}, idx}, acc ->
      if compare(left, right), do: acc + idx + 1, else: acc
    end)
  end

  def part2(input) do
    sorted = Enum.sort(input ++ [[[2]], [[6]]], &compare/2)
    idx2 = 1 + Enum.find_index(sorted, fn p -> p == [[2]] end)
    idx6 = 1 + Enum.find_index(sorted, fn p -> p == [[6]] end)

    idx2 * idx6
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n\n", trim: true)
    |> Enum.map(&to_list/1)
  end

  def read_input2(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> Jason.decode!(line) end)
  end

  # special case
  defp compare([], []), do: :both

  defp compare([], _), do: true

  defp compare(_, []), do: false

  defp compare([l | left], [r | right]) when is_integer(l) and is_integer(r) do
    cond do
      l < r -> true
      l > r -> false
      l == r -> compare(left, right)
    end
  end

  defp compare([l | left], [r | right]) when is_list(l) and is_list(r) do
    result = compare(l, r)

    case result do
      :both -> compare(left, right)
      _ -> result
    end
  end

  defp compare([l | left], [r | right]) when is_integer(l) and is_list(r) do
    compare([[l] | left], [r | right])
  end

  defp compare([l | left], [r | right]) when is_list(l) and is_integer(r) do
    compare([l | left], [[r] | right])
  end

  defp to_list(pair) do
    [l, r] = String.split(pair, "\n", trim: true)

    {Jason.decode!(l), Jason.decode!(r)}
  end
end
