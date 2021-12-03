defmodule Day03 do
  @moduledoc """
  Documentation for `Day03`.
  """

  def part1(bits) do
    part1(bits, "", "")
  end

  defp part1([], gamma, epsilon) do
    String.to_integer(gamma, 2) * String.to_integer(epsilon, 2)
  end

  defp part1(bits, gamma, epsilon) do
    splitbits = Enum.map(bits, &String.split_at(&1, 1))
    column = Enum.map(splitbits, &elem(&1, 0))

    {zeros, ones} =
      Enum.reduce(column, {0, 0}, fn b, {zeros, ones} ->
        if b == "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
      end)

    newbits =
      Enum.map(splitbits, &elem(&1, 1))
      |> Enum.filter(&(&1 != ""))

    if zeros > ones do
      part1(newbits, gamma <> "0", epsilon <> "1")
    else
      part1(newbits, gamma <> "1", epsilon <> "0")
    end
  end

  def part2(bits) do
    oxy = part2(bits, 0, :greater)
    co2 = part2(bits, 0, :fewer)

    oxy * co2
  end

  defp part2([bit], _, _), do: String.to_integer(bit, 2)

  defp part2(bits, pos, check) do
    column = Enum.map(bits, &String.at(&1, pos))

    {zeros, ones} =
      Enum.reduce(column, {0, 0}, fn b, {zeros, ones} ->
        if b == "0", do: {zeros + 1, ones}, else: {zeros, ones + 1}
      end)

    bit =
      if check == :greater do
        if ones >= zeros, do: "1", else: "0"
      else
        if ones >= zeros, do: "0", else: "1"
      end

    newbits = Enum.filter(bits, &(String.at(&1, pos) == bit))

    part2(newbits, pos + 1, check)
  end
end
