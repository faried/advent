defmodule Day07 do
  @cards "23456789TJQKA" |> String.graphemes() |> Enum.with_index() |> Map.new()
  @cards2 "J23456789TQKA" |> String.graphemes() |> Enum.with_index() |> Map.new()
  @j @cards2["J"]

  def part1(input) do
    input
    |> parse(@cards)
    |> calculate(&card_to_type/1)
  end

  def part2(input) do
    input
    |> parse(@cards2)
    |> calculate(&card_to_type2/1)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp parse(input, cmap) do
    input
    |> Enum.map(fn line ->
      [card, bid] = String.split(line, " ", trim: true)

      {card_to_numbers(card, cmap), String.to_integer(bid)}
    end)
    |> Map.new()
  end

  defp card_to_numbers(card, cmap) do
    card
    |> String.graphemes()
    |> Enum.map(fn card -> cmap[card] end)
  end

  # should be a better way of ordering types of cards but ints work
  defp card_to_type(cardnum) do
    same =
      cardnum
      |> Enum.frequencies()
      |> Map.values()
      |> Enum.sort(:desc)

    case same do
      # :fiveofakind
      [5] -> 7
      # :fourofakind
      [4, 1] -> 6
      # :fullhouse
      [3, 2] -> 5
      # :threeofakind
      [3, 1, 1] -> 4
      # :twopair
      [2, 2, 1] -> 3
      # :onepair
      [2, 1, 1, 1] -> 2
      # :high
      [1, 1, 1, 1, 1] -> 1
    end
  end

  # extract jokers, find the most frequent other card, promote joker to that card
  # if all other cards are equal, like [2, 3, 4, 5], set joker to the highest value
  defp card_to_type2(cardnum) do
    {jokers, rest} = Enum.split_with(cardnum, &(&1 == @j))

    case jokers do
      [] ->
        card_to_type(cardnum)

      [@j, @j, @j, @j, @j] ->
        @cards2["A"]
        |> List.duplicate(5)
        |> card_to_type()

      _ ->
        # this does slightly more work than necessary
        rest
        |> Enum.frequencies()
        # sort by frequency and get the most frequent card(s)
        |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
        |> Enum.group_by(fn {_card, count} -> count end)
        |> Enum.max()
        |> elem(1)
        # sort by card and promote highest value
        |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
        |> hd()
        |> elem(0)
        |> List.duplicate(Enum.count(jokers))
        |> Enum.concat(rest)
        |> card_to_type()
    end
  end

  defp stronger(cardnum1, cardnum2) do
    Enum.zip(cardnum1, cardnum2)
    |> Enum.reduce_while(nil, fn {c1, c2}, stronger ->
      cond do
        c1 > c2 -> {:halt, true}
        c1 < c2 -> {:halt, false}
        c1 == c2 -> {:cont, stronger}
      end
    end)
  end

  defp calculate(input, typefn) do
    input
    |> Map.keys()
    # get type of each card and group by type, sorted low to high
    |> Enum.map(fn card -> {card, typefn.(card)} end)
    |> Enum.group_by(fn {_card, type} -> type end)
    |> Enum.sort()
    # for each type, sort individual cards from high to low
    |> Enum.reduce([], fn {_, cards}, acc ->
      cards
      |> Enum.map(&elem(&1, 0))
      |> Enum.sort(&stronger/2)
      |> Enum.concat(acc)
    end)
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.map(fn {card, rank} -> input[card] * rank end)
    |> Enum.sum()
  end
end
