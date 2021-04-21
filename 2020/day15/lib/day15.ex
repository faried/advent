defmodule Day15 do
  def readinput() do
    # [0, 3, 6]
    [13, 0, 10, 12, 1, 5, 8]
  end

  def part1(input \\ readinput()) do
    run(input, 2020)
  end

  def part2(input \\ readinput()) do
    run(input, 30000000)
  end

  def run(input, target) do
    Enum.with_index(input, 1)
    |> Enum.reduce(%{}, fn {number, turn}, turns -> Map.put(turns, number, {turn, -1}) end)
    |> loop(List.last(input), length(input), target)
  end

  def loop(_turnsmap, number, turn, turn), do: number

  def loop(turnsmap, prevspoke, turn, endturn) do
    {say, newmap} =
      Map.get(turnsmap, prevspoke, {-1, -1})
      |> nextsay(turnsmap, prevspoke, turn)

    loop(newmap, say, turn+1, endturn)
  end

  # number does not exist, add it
  def nextsay({-1, -1}, turnsmap, prevspoke, turn) do
    {0, Map.put(turnsmap, prevspoke, {turn, -1})}
  end

  # number was said once before (possibly starting number?)
  def nextsay({turn, -1}, turnsmap, _prevspoke, turn) do
    {z1, _} = Map.get(turnsmap, 0, {-1, -1})
    {0, Map.put(turnsmap, 0, {turn+1, z1})}
  end

  # usual case: number was said at least twice
  def nextsay({prev1, prev2}, turnsmap, _prevspoke, turn) do
    newsay = prev1 - prev2
    {s1, _} = Map.get(turnsmap, newsay, {-1, -1})
    {newsay, Map.put(turnsmap, newsay, {turn+1, s1})}
  end
end
