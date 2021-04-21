defmodule Day25 do
  def readinput() do
    File.read!("25.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1([carpub, doorpub] \\ readinput()) do
    # carloop = IO.inspect(findloop(carpub), label: "car loop")
    doorloop = IO.inspect(findloop(doorpub), label: "door loop")

    IO.inspect(loop(carpub, doorloop), label: "encryption key")
  end

  def loop(subject, loopsize, current \\ 1)
  def loop(_subject, 0, current), do: current

  def loop(subject, loopsize, current),
    do: loop(subject, loopsize - 1, rem(current * subject, 20_201_227))

  def findloop(target, current \\ 1, rounds \\ 0)
  def findloop(target, current, rounds) when target == current, do: rounds

  def findloop(target, current, rounds),
    do: findloop(target, rem(current * 7, 20_201_227), rounds + 1)
end
