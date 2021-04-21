defmodule Day12.Navigation1 do
  @compass [:north, :east, :south, :west]

  def run([], _dir, {x, y}), do: abs(x) + abs(y)

  def run([nav | navigation], dir, pos) do
    {newdir, newpos} = move(nav, dir, pos)
    run(navigation, newdir, newpos)
  end

  def move({"F", dist}, dir, pos) do
    case dir do
      :north -> move({"N", dist}, dir, pos)
      :south -> move({"S", dist}, dir, pos)
      :east -> move({"E", dist}, dir, pos)
      :west -> move({"W", dist}, dir, pos)
    end
  end

  def move({"N", dist}, dir, {x, y}), do: {dir, {x, y + dist}}
  def move({"S", dist}, dir, {x, y}), do: {dir, {x, y - dist}}
  def move({"E", dist}, dir, {x, y}), do: {dir, {x + dist, y}}
  def move({"W", dist}, dir, {x, y}), do: {dir, {x - dist, y}}

  def move({"R", 0}, dir, pos), do: {dir, pos}
  def move({"R", 360}, dir, pos), do: {dir, pos}

  def move({"R", angle}, dir, pos) do
    multiple = div(angle, 90)
    newdir = Enum.at(@compass, rem(multiple + Enum.find_index(@compass, &(&1 == dir)), 4))
    {newdir, pos}
  end

  def move({"L", angle}, dir, pos), do: move({"R", 360 - angle}, dir, pos)
end

defmodule Day12.Navigation2 do
  def run([], _dir, {x, y}, _wp), do: abs(x) + abs(y)

  def run([nav | navigation], dir, pos, wp) do
    {newdir, newpos, newwp} = move(nav, dir, pos, wp)
    run(navigation, newdir, newpos, newwp)
  end

  def move({"F", dist}, dir, {x, y}, {wpx, wpy} = wp) do
    case dir do
      :north -> {dir, {x + dist * wpx, y + dist * wpy}, wp}
      :south -> {dir, {x + dist * wpx, y - dist * wpy}, wp}
      :east -> {dir, {x + dist * wpx, y + dist * wpy}, wp}
      :west -> {dir, {x - dist * wpx, y + dist * wpy}, wp}
    end
  end

  def move({"N", dist}, dir, pos, {wpx, wpy}), do: {dir, pos, {wpx, wpy + dist}}
  def move({"S", dist}, dir, pos, {wpx, wpy}), do: {dir, pos, {wpx, wpy - dist}}
  def move({"E", dist}, dir, pos, {wpx, wpy}), do: {dir, pos, {wpx + dist, wpy}}
  def move({"W", dist}, dir, pos, {wpx, wpy}), do: {dir, pos, {wpx - dist, wpy}}

  def move({"R", 0}, dir, pos, wp), do: {dir, pos, wp}
  def move({"R", 360}, dir, pos, wp), do: {dir, pos, wp}

  def move({"R", angle}, dir, pos, {wpx, wpy}) do
    case angle do
      90 -> {dir, pos, {wpy, -wpx}}
      180 -> {dir, pos, {-wpx, -wpy}}
      270 -> {dir, pos, {-wpy, wpx}}
    end
  end

  def move({"L", angle}, dir, pos, wp), do: move({"R", 360 - angle}, dir, pos, wp)
end

defmodule Day12 do
  alias Day12.Navigation1
  alias Day12.Navigation2

  def readinput() do
    File.read!("12.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&command/1)
  end

  def command(cmdstr) do
    {dir, dist} = String.split_at(cmdstr, 1)
    {dir, String.to_integer(dist)}
  end

  def part1(input \\ readinput()) do
    input
    |> Navigation1.run(:east, {0, 0})
  end

  def part2(input \\ readinput()) do
    input
    |> Navigation2.run(:east, {0, 0}, {10, 1})
  end
end
