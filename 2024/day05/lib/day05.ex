defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """

  def part1({rules, updates}) do
    Enum.reduce(updates, 0, fn update, acc ->
      if ordered?(update, rules) do
        midpoint = div(Enum.count(update), 2)
        acc + Enum.at(update, midpoint)
      else
        acc
      end
    end)
  end

  def part2({rules, updates}) do
    Enum.reject(updates, &ordered?(&1, rules))
    |> Enum.reduce(0, fn update, acc ->
      update = reorder(update, rules)
      midpoint = div(Enum.count(update), 2)
      acc + Enum.at(update, midpoint)
    end)
  end

  def ordered?(update, rules) do
    update
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(&MapSet.member?(rules, &1))
  end

  def reorder(update, rules) do
    reordered = reorder(update, rules, [])

    if ordered?(reordered, rules) do
      reordered
    else
      reorder(reordered, rules)
    end
  end

  def reorder([page], _, acc), do: [page | acc] |> Enum.reverse()

  def reorder([a, b | rest], rules, acc) do
    # pages are either in the order they appear in the rules
    # or in reverse order.  there is no case where a page
    # in an update is not in the rules.
    if MapSet.member?(rules, [a, b]) do
      reorder([b | rest], rules, [a | acc])
    else
      reorder([a | rest], rules, [b | acc])
    end
  end

  def read_input(fname) do
    [rules, updates] =
      File.read!("priv/#{fname}")
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      Enum.map(rules, fn rule ->
        rule
        |> String.split("|", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> MapSet.new()

    updates =
      Enum.map(updates, fn update ->
        update
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end
end
