defmodule Day07.Fns do
  # revmap: map a bag to the list of bags that contain it
  def revmap(_container, [], bagmap), do: bagmap

  def revmap(container, [bag | bags], bagmap) do
    bag = String.replace(bag, ".", "")

    # ugly
    bagmap = Map.update(bagmap, bag, [container], fn cur -> [container | cur] end)

    revmap(container, bags, bagmap)
  end

  # map a bag to a map of bags it contains, and how many
  # %{"wavy lavender" => %{"light magenta" => 1, "striped cyan" => 2}}
  def nummap(_container, [], bagmap), do: bagmap

  def nummap(container, [bag | bags], bagmap) do
    bag = String.replace(bag, ".", "")

    [count, containedbag] =
      Regex.scan(~r/(\d+)\s(.*)/, bag, capture: :all_but_first)
      |> hd()

    # ugly
    bagmap =
      Map.update(bagmap, container, %{containedbag => String.to_integer(count)}, fn cur ->
        Map.put(cur, containedbag, String.to_integer(count))
      end)

    nummap(container, bags, bagmap)
  end

  def cancontain(_bagmap, [], mapset), do: Enum.count(mapset)

  def cancontain(bagmap, [bag | bags], mapset) do
    containers =
      Map.get(bagmap, bag, [])
      |> Enum.reject(fn nextbag -> nextbag == bag or nextbag in mapset end)

    newmapset =
      containers
      |> MapSet.new()
      |> MapSet.union(mapset)

    cancontain(bagmap, bags ++ containers, newmapset)
  end

  def totalbags(bagmap, bag) do
    contains = Map.get(bagmap, bag, %{})

    # ugly, not tail-recursive
    if contains == %{} do
      0
    else
      immediate =
        Map.values(contains)
        |> Enum.sum()

      inside =
        Enum.map(contains, fn {ibag, icount} -> icount * totalbags(bagmap, ibag) end)
        |> Enum.sum()

      immediate + inside
    end
  end
end

defmodule Day07 do
  alias Day07.Fns

  def readinput() do
    File.read!("7.input.txt")
    |> String.replace(~r/ bag(s)?/, "")
    |> String.replace(", ", ".")
    |> String.split("\n", trim: true)
    |> Enum.reject(fn s -> String.contains?(s, "no other") end)
  end

  def part1(input \\ readinput()) do
    input
    |> Enum.map(&String.replace(&1, ~r/(\d+) /, ""))
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [container, contains] ->
      [container, String.split(contains, ".", trim: true)]
    end)
    |> Enum.reduce(%{}, fn [container | [contains | _]], acc ->
      Fns.revmap(container, contains, acc)
    end)
    |> Fns.cancontain(["shiny gold"], MapSet.new())
  end

  def part2(input \\ readinput()) do
    input
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [container, contains] ->
      [container, String.split(contains, ".", trim: true)]
    end)
    |> Enum.reduce(%{}, fn [container | [contains | _]], acc ->
      Fns.nummap(container, contains, acc)
    end)
    |> Fns.totalbags("shiny gold")
  end
end
