defmodule Day14 do
  def readinput() do
    File.read!("14.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
  end

  def parse(["mask", "=", maskstr]), do: {:setmask, String.graphemes(maskstr)}

  def parse([memstr, "=", value]) do
    addr =
      Regex.run(~r/\[(\d+)\]/, memstr, capture: :all_but_first)
      |> hd()

    {:setmem, String.to_integer(addr), String.to_integer(value)}
  end

  def tobinlist(number) do
    number
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.graphemes()
  end

  def part1(program \\ readinput()) do
    run(program, &run1/2)
  end

  def part2(program \\ readinput()) do
    run(program, &run2/2)
  end

  def run(program, reducer) do
    Enum.reduce(program, %{}, reducer)
    |> Map.drop([:mask])
    |> Map.values()
    |> Enum.reduce(&Kernel.+/2)
  end

  def run1({:setmask, mask}, memory), do: Map.put(memory, :mask, mask)

  def run1({:setmem, location, value}, memory) do
    maskedval = applymask1(tobinlist(value), Map.get(memory, :mask), [])
    Map.put(memory, location, maskedval)
  end

  def applymask1([], [], sofar) do
    sofar
    |> Enum.reverse()
    |> Enum.join("")
    |> String.to_integer(2)
  end

  def applymask1([digit | num], [m | mask], sofar) do
    case m do
      "X" -> applymask1(num, mask, [digit | sofar])
      "0" -> applymask1(num, mask, ["0" | sofar])
      "1" -> applymask1(num, mask, ["1" | sofar])
    end
  end

  def run2({:setmask, mask}, memory), do: Map.put(memory, :mask, mask)

  def run2({:setmem, location, value}, memory) do
    location
    |> tobinlist()
    |> mask2(Map.get(memory, :mask), [])
    |> Enum.reduce(memory, fn addr, memory -> Map.put(memory, addr, value) end)
  end

  # argh
  # bad code below

  def exp2(0), do: 1
  def exp2(n) when n > 0, do: 2 * exp2(n - 1)

  def mask2([], [], sofar) do
    addrmask = Enum.reverse(sofar)

    # find the "X" indexes in the mask, will return something like [30, 35]
    xs =
      Enum.with_index(addrmask)
      |> Enum.filter(fn {a, _} -> a == "X" end)
      |> Enum.map(&elem(&1, 1))

    numxs = Enum.count(xs)

    # for numxs = 4, this will return ["00", "01", "10", "11"] with indexes, as
    # [{"0", 0}, {"0", 1}],
    # [{"0", 0}, {"1", 1}],
    # [{"1", 0}, {"0", 1}],
    # [{"1", 0}, {"1", 1}]
    # the second digit indexes into xs
    # the first digit is what we replace into that position
    for i <- 0..(exp2(numxs) - 1) do
      Integer.to_string(i, 2)
      |> String.pad_leading(numxs, "0")
      |> String.graphemes()
      |> Enum.with_index()
    end
    |> Enum.map(fn v1 ->
      replace(addrmask, xs, v1)
      |> Enum.join()
      |> String.to_integer(2)
    end)
  end

  def mask2([digit | num], [m | mask], sofar) do
    case m do
      "X" -> mask2(num, mask, ["X" | sofar])
      "0" -> mask2(num, mask, [digit | sofar])
      "1" -> mask2(num, mask, ["1" | sofar])
    end
  end

  def replace(sofar, _xs, []), do: sofar

  def replace(sofar, xs, [{v, i} | rest]) do
    List.replace_at(sofar, Enum.at(xs, i), v)
    |> replace(xs, rest)
  end
end
