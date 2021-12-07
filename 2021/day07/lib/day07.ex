defmodule Day07 do
  @moduledoc """
  Documentation for `Day07`.
  """

  def part1(crabs) do
    calculate(crabs, &move_to1/2)
  end

  def part2(crabs) do
    calculate(crabs, &move_to2/2)
  end

  defp calculate(crabs, func) do
    sorted = Enum.sort(crabs)

    min = List.first(sorted)
    max = List.last(sorted)

    Enum.reduce(min..max, %{}, fn dist, acc ->
      Map.put(acc, dist, func.(crabs, dist))
    end)
    |> Map.to_list()
    |> Enum.sort(fn {_, c1}, {_, c2} -> c1 < c2 end)
    |> List.first()
    |> elem(1)
  end

  defp move_to1(crabs, pos, steps \\ 0)

  defp move_to1([], _, steps), do: steps

  defp move_to1([crab | crabs], pos, steps) do
    move_to1(crabs, pos, steps + abs(crab - pos))
  end

  defp move_to2(crabs, pos, cost \\ 0)

  defp move_to2([], _, cost), do: cost

  defp move_to2([crab | crabs], pos, cost) do
    move_cost = Enum.sum(0..abs(crab - pos))
    move_to2(crabs, pos, cost + move_cost)
  end
end
