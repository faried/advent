defmodule Day02 do
  @moduledoc """
  Documentation for `Day02`.
  """

  def part1(commands), do: part1(commands, 0, 0)

  def part1([], horiz, depth), do: horiz * depth

  def part1([command | commands], horiz, depth) do
    {change_h, _, change_d } = parse(command)
    part1(commands, horiz + change_h, depth + change_d)
  end

  def part2(commands), do: part2(commands, 0, 0, 0)

  def part2([], horiz, depth, _), do: horiz * depth

  def part2([command | commands], horiz, depth, aim) do
    {change_h, change_d, change_aim} = parse(command, aim)
    part2(commands, horiz + change_h, depth + change_d, aim + change_aim)
  end

  defp parse(command, aim \\ 0)

  defp parse("forward " <> horiz, aim) do
    i = String.to_integer(horiz)
    {i, aim * i, 0}
  end

  defp parse("down " <> depth,  _), do: {0, 0, String.to_integer(depth)}
  defp parse("up " <> depth, _), do: {0, 0, 0 - String.to_integer(depth)}

end
