defmodule Day23 do
  def readinput() do
    "389125467"
    # "853192647"
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input \\ readinput()) do
    loop(input, 0)
  end

  def part2(input \\ readinput()) do
    max = Enum.max(input) + 1
    needed = 1_000_000 - length(input)
    fullinput = input ++ (Stream.iterate(max, & &1+1) |> Enum.take(needed))
    loop(fullinput, 0, 10_000_000, 2)
  end

  def loop(cups, idx, count \\ 100, part \\ 1)

  def loop(cups, _, 0, 1) do
    idx = Enum.find_index(cups, fn c -> c == 1 end)
    Stream.cycle(cups)
    |> Enum.take(idx+length(cups))
    |> Enum.drop(idx+1)
    |> Enum.join("")
  end

  def loop(cups, _, 0, 2) do
    idx = Enum.find_index(cups, fn c -> c == 1 end)
    Stream.cycle(cups)
    |> Enum.take(idx+3)
    |> Enum.drop(idx+1)
  end

  def loop(cups, idx, count, part) do
    if rem(count, 1_000) == 0, do: IO.puts(count)
    current = Enum.at(cups, idx)
    scups = Stream.cycle(cups)
    toremove = Enum.take(scups, idx+4) |> Enum.drop(idx+1)
    remaining = Enum.reject(cups, fn c -> c in toremove end)
    sorted = Enum.sort(remaining, :desc)
    highest = Enum.at(sorted, 0)
    dest = Enum.find(sorted, fn c -> c < current end) || highest
    destidx = Enum.find_index(remaining, fn c -> c == dest end)
    {left, right} = Enum.split(remaining, destidx + 1)
    reconstituted = left ++ toremove ++ right
    nextidx = rem(Enum.find_index(reconstituted, fn c -> c == current end) + 1, length(cups))

    loop(reconstituted, nextidx, count-1, part)
  end
end
