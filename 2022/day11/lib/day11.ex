defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """

  alias Day11.Monkey

  def part1(input, turns \\ 20) do
    {monkeys, first, last} = prepare(input)

    [m1, m2] =
      Enum.reduce(0..(turns - 1), monkeys, fn _, acc ->
        turn(acc, first, last)
      end)
      |> Map.values()
      |> Enum.sort_by(fn m -> m.inspected end, :desc)
      |> Enum.take(2)

    m1.inspected * m2.inspected
  end

  def part2(input, turns \\ 10_000) do
    {monkeys, first, last} = prepare(input)

    # can't take credit for this
    modallby =
      monkeys
      |> Map.values()
      |> Enum.map(fn monkey -> monkey.modby end)
      |> Enum.product()

    [m1, m2] =
      Enum.reduce(0..(turns - 1), monkeys, fn _, acc ->
        turn(acc, first, last, modallby, false)
      end)
      |> Map.values()
      |> Enum.sort_by(fn m -> m.inspected end, :desc)
      |> Enum.take(2)

    m1.inspected * m2.inspected
  end

  defp prepare(input) do
    monkeymap =
      input
      |> Enum.map(&Monkey.new/1)
      |> Enum.map(fn monkey -> {monkey.number, monkey} end)
      |> Map.new()

    {first, last} = Enum.min_max(Map.keys(monkeymap))

    {monkeymap, first, last}
  end

  defp turn(monkeys, first, last, mod \\ nil, divide \\ true) do
    Enum.reduce(first..last, monkeys, fn idx, acc ->
      {moves, newmonkey} = Monkey.round(acc[idx], mod, divide)

      acc = Map.put(acc, idx, newmonkey)

      # [{3, 620}, {3, 500}] -> %{3 => [620, 500]}
      moves
      |> Enum.group_by(fn {monkey, _} -> monkey end, fn {_, item} -> item end)
      |> Enum.reduce(acc, fn {idx, items}, acc ->
        Map.update!(acc, idx, fn monkey -> Monkey.add_items(monkey, items) end)
      end)
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n\n", trim: true)
  end
end
