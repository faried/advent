defmodule Day13 do
  def readinput() do
    [start, busdata] =
      File.read!("13.input.txt")
      |> String.split("\n", trim: true)

    [String.to_integer(start), String.split(busdata, ",")]
  end

  def part1([start, buses] \\ readinput()) do
    buses =
      buses
      |> Enum.filter(&(&1 != "x"))
      |> Enum.map(&String.to_integer/1)

    bus =
      Enum.map(buses, fn bus -> {bus, bus - rem(start, bus)} end)
      |> Enum.min(fn {_b1, t1}, {_b2, t2} -> t1 < t2 end)

    elem(bus, 0) * elem(bus, 1)
  end

  def part2([_, buses] \\ readinput()) do
    buses =
      buses
      |> Enum.map(fn b -> if b != "x", do: String.to_integer(b), else: "x" end)
      |> Enum.with_index()
      |> Enum.filter(fn {b, _} -> b != "x" end)

    first =
      buses
      |> List.first()
      |> elem(0)

    loop(buses, first)
  end

  def loop(buses, time) do
    mods =
      buses
      |> Enum.map(fn {b, offset} -> rem(time + offset, b) end)

    if Enum.all?(mods, &(&1 == 0)) do
      time
    else
      # does too much work
      step =
        mods
        |> Enum.with_index()
        # find indexes in mod list where the mod was 0
        |> Enum.filter(fn {v, _i} -> v == 0 end)
        # use the indexes to find the bus times that resulted in mod 0
        |> Enum.map(fn {_v, i} -> Enum.at(buses, i) |> elem(0) end)
        |> Enum.reduce(1, &Kernel.*/2)

      loop(buses, time + step)
    end
  end
end
