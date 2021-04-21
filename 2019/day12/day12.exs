defmodule Day12 do
  def input(path) do
    contents = File.read!(path) |> String.trim()

    Regex.scan(~r/(\d+)/, contents, capture: :first)
    |> Stream.map(&List.first/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(3)
    |> Enum.map(fn moonpos -> moonpos ++ [0, 0, 0] end)
  end

  # [1, 2, 3, 4] ->
  # [1, 2], [1, 3], [1, 4], [2, 3], [2, 4], [3, 4]
  defp comb2p(_, [], acc), do: acc

  defp comb2p(one, [two | rest], acc) do
    comb2p(one, rest, [[one, two] | acc])
  end

  def comb2(ls, acc \\ [])

  def comb2([_], acc), do: Enum.reverse(acc)
  def comb2([one | rest], acc) do
    comb2(rest, comb2p(one, rest, []) ++ acc)
  end

  def gravity(lmoon, rmoon, lg \\ [], rg \\ [], n \\ 0)

  def gravity(_, _, lg, rg, 3), do: [[0, 0, 0] ++ lg, [0, 0, 0] ++ rg]

  def gravity([l | lmoon], [r | rmoon], lg, rg, n) do
    cond do
      l < r ->
        gravity(lmoon, rmoon, [1 | lg], [-1 | rg], n+1)
      r < l ->
        gravity(lmoon, rmoon, [-1 | lg], [1 | rg], n+1)
      true ->
        gravity(lmoon, rmoon, [0 | lg], [0 | rg], n+1)
    end
  end

  def apply_gravity(left, right) do
    [leftg, rightg] = gravity(left, right)
    retleft = Enum.zip(left, leftg) |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.sum/1)
    retright = Enum.zip(right, rightg) |> Enum.map(&Tuple.to_list/1) |> Enum.map(&Enum.sum/1)

    [retleft, retright]
  end

  def calcenergy([[left, right] | moons], energy) do

  end

  def part1(moons, 0) do
  end

  def part1(moons, _n) do
    comb2(moons)
    |> Enum.map(fn [left, right] -> apply_gravity(left, right) end)
  end

  def part2(_moons) do
  end

  def run(path \\ "/tmp/12.input") do
    moons = input(path)

    part1(moons, 1000)
  end
end
