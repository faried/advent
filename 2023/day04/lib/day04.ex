defmodule Day04 do
  def part1(input) do
    input
    |> Enum.reduce(0, fn {_cardnum, wins}, acc ->
      if wins == 0, do: acc, else: acc + 2 ** (wins - 1)
    end)
  end

  def part2(input) do
    input
    |> Map.keys()
    |> loop(input, 0)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> parse()
  end

  defp parse(input) do
    Enum.reduce(input, %{}, fn line, acc ->
      [card, numbers] = String.split(line, ": ")
      [_, cardnum] = String.split(card, " ", trim: true)
      [winning, scratched] = String.split(numbers, " | ")
      wlist = String.split(winning, " ", trim: true) |> MapSet.new()
      slist = String.split(scratched, " ", trim: true) |> MapSet.new()
      wins = MapSet.intersection(wlist, slist) |> Enum.count()
      Map.put(acc, String.to_integer(cardnum), wins)
    end)
  end

  defp loop([], _cards, count), do: count

  defp loop([card | cardnums], cards, count) do
    wins = cards[card]

    if wins == 0 do
      loop(cardnums, cards, count + 1)
    else
      newcardnums = (card + 1)..(card + wins) |> Range.to_list()

      (newcardnums ++ cardnums)
      |> loop(cards, count + 1)
    end
  end
end
