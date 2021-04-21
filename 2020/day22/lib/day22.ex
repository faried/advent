defmodule Day22 do
  def readinput() do
    File.read!("22.input.txt")
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn s ->
      String.split(s, "\n", trim: true) |> tl() |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1([player1, player2] \\ readinput()) do
    play1(player1, player2)
  end

  def play1([], cards), do: score(Enum.reverse(cards))
  def play1(cards, []), do: score(Enum.reverse(cards))

  def play1([c1 | cards1], [c2 | cards2]) when c1 > c2, do: play1(cards1 ++ [c1, c2], cards2)
  def play1([c1 | cards1], [c2 | cards2]) when c2 > c1, do: play1(cards1, cards2 ++ [c2, c1])

  def part2([player1, player2] \\ readinput()) do
    play2(player1, player2)
  end

  def play2(cards1, cards2, p1set \\ MapSet.new(), p2set \\ MapSet.new())

  def play2([], cards, _, _), do: {:player2, score(Enum.reverse(cards))}
  def play2(cards, [], _, _), do: {:player1, score(Enum.reverse(cards))}

  def play2([c1 | cards1] = p1cards, [c2 | cards2] = p2cards, p1set, p2set) do
    cond do
      p1cards in p1set or p2cards in p2set ->
        {:player1, true}

      c1 <= length(cards1) and c2 <= length(cards2) ->
        case play2(Enum.take(cards1, c1), Enum.take(cards2, c2)) do
          {:player1, _} ->
            play2(
              cards1 ++ [c1, c2],
              cards2,
              MapSet.put(p1set, p1cards),
              MapSet.put(p2set, p2cards)
            )

          {:player2, _} ->
            play2(
              cards1,
              cards2 ++ [c2, c1],
              MapSet.put(p1set, p1cards),
              MapSet.put(p2set, p2cards)
            )
        end

      c1 > c2 ->
        play2(cards1 ++ [c1, c2], cards2, MapSet.put(p1set, p1cards), MapSet.put(p2set, p2cards))

      true ->
        play2(cards1, cards2 ++ [c2, c1], MapSet.put(p1set, p1cards), MapSet.put(p2set, p2cards))
    end
  end

  def score(cards) do
    Stream.zip(cards, Stream.iterate(1, &(&1 + 1)))
    |> Stream.map(fn {a, b} -> a * b end)
    |> Enum.sum()
  end
end
