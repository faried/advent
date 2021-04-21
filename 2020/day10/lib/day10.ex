defmodule Day10.Adapter do
  defstruct jolts: 0, input: nil

  def new(jolts) do
    %__MODULE__{jolts: jolts, input: (jolts - 3)..(jolts - 1)}
  end
end

defmodule Day10 do
  alias Day10.Adapter

  def readinput(fname \\ "10.input.txt") do
    File.read!(fname)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.map(&Adapter.new/1)
  end

  def part1(adapters \\ readinput()) do
    chain(adapters)
  end

  # threecount starts with 1 to account for the last adapter <-> your device
  def chain(adapters, jolts \\ 0, onecount \\ 0, threecount \\ 1)

  def chain([], _jolts, onecount, threecount), do: onecount * threecount
    # do: {onecount, threecount, onecount * threecount}

  def chain(adapters, jolts, onecount, threecount) do
    # since the list is sorted, the adapter we want is always the first one
    {adapter, rest} = List.pop_at(adapters, 0)
    onecount = if adapter.jolts - jolts == 1, do: onecount + 1, else: onecount
    threecount = if adapter.jolts - jolts == 3, do: threecount + 1, else: threecount
    chain(rest, adapter.jolts, onecount, threecount)
  end
end
