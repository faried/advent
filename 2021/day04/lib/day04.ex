defmodule Day04 do
  @moduledoc """
  Documentation for `Day04`.
  """

  def bingo({draws, boards}) do
    lookups = for _ <- 1..Enum.count(boards), do: List.duplicate(false, 25) |> Enum.chunk_every(5)
    bingo(draws, boards, lookups, [], MapSet.new())
  end

  defp bingo([], _, _, scores, _), do: Enum.reverse(scores)

  defp bingo([draw | draws], boards, lookups, scores, wins) do
    positions = findpos(draw, boards)
    marked = mark(positions, lookups)

    {score, new_wins} =
      Enum.with_index(marked)
      |> Enum.reduce({nil, wins}, fn {lookup, idx}, {score, wins} ->
        if idx in wins do
          {score, wins}
        else
          if winner(lookup) do
            new_wins = MapSet.put(wins, idx)
            # IO.puts("board #{idx} won with #{draw}")
            score = unmarked(lookup, Enum.at(boards, idx)) * draw
            {score, new_wins}
          else
            {score, wins}
          end
        end
      end)

    if score do
      bingo(draws, boards, marked, [score | scores], new_wins)
    else
      bingo(draws, boards, marked, scores, new_wins)
    end
  end

  defp findpos(draw, boards, poslist \\ [])

  defp findpos(_, [], poslist), do: Enum.reverse(poslist)

  defp findpos(draw, [board | boards], poslist) do
    pos =
      Enum.with_index(board)
      |> Enum.map(fn {row, rownum} -> {rownum, Enum.find_index(row, fn i -> i == draw end)} end)
      |> Enum.filter(fn {_row, col} -> col != nil end)
      |> List.first()

    findpos(draw, boards, [pos | poslist])
  end

  defp mark(positions, lookups, marked \\ [])

  defp mark([], [], marked), do: Enum.reverse(marked)

  # skip boards which do not have the draw
  defp mark([nil | positions], [lookup | lookups], marked),
    do: mark(positions, lookups, [lookup | marked])

  defp mark([{row, col} | positions], [lookup | lookups], marked) do
    lookup =
      Enum.with_index(lookup)
      |> Enum.map(fn {lrow, idx} ->
        if idx == row do
          List.replace_at(lrow, col, true)
        else
          lrow
        end
      end)

    mark(positions, lookups, [lookup | marked])
  end

  defp winner(lookup) do
    if Enum.map(lookup, &Enum.all?/1) |> Enum.any?() do
      true
    else
      # rotate
      for(r <- 0..4, c <- 0..4, do: Enum.at(lookup, c) |> Enum.at(r))
      |> Enum.chunk_every(5)
      |> Enum.map(&Enum.all?/1)
      |> Enum.any?()
    end
  end

  defp unmarked(lookup, board) do
    Enum.with_index(lookup)
    |> Enum.flat_map(fn {row, r} ->
      Enum.with_index(row)
      |> Enum.map(fn {val, c} ->
        if not val do
          Enum.at(board, r)
          |> Enum.at(c)
        else
          0
        end
      end)
    end)
    |> Enum.sum()
  end
end
