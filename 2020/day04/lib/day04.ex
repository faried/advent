defmodule Day04 do
  @requiredkeys MapSet.new(~w{byr iyr eyr hgt hcl ecl pid})
  @eyecolors MapSet.new(~w{amb blu brn gry grn hzl oth})

  # returns a list of maps
  def readinput() do
    File.read!("4.input.txt")
    |> String.split("\n\n")
    |> Enum.map(&String.replace(&1, "\n", " "))
    |> Enum.map(fn entry ->
      Regex.scan(~r/(\w+):(\S+)/, entry, capture: :all_but_first)
      |> Enum.map(&List.to_tuple/1)
      |> Map.new()
    end)
  end

  def allkeys?(entry) do
    entry
    |> Enum.filter(fn k -> k != "cid" end)
    |> MapSet.new()
    |> MapSet.equal?(@requiredkeys)
  end

  def valid?({"byr", value}),
    do: String.length(value) == 4 && String.to_integer(value) in 1920..2002

  def valid?({"iyr", value}),
    do: String.length(value) == 4 && String.to_integer(value) in 2010..2020

  def valid?({"eyr", value}),
    do: String.length(value) == 4 && String.to_integer(value) in 2020..2030

  def valid?({"hgt", value}) do
    case hd(Regex.scan(~r/(\d+)(\w+)/, value, capture: :all_but_first)) do
      [cm, "cm"] -> String.to_integer(cm) in 150..193
      [inch, "in"] -> String.to_integer(inch) in 59..76
      _ -> false
    end
  end

  def valid?({"hcl", value}),
    do:
      String.first(value) == "#" && String.length(value) == 7 &&
        Regex.match?(~r/[0-9a-f]/, String.trim_leading(value, "#"))

  def valid?({"ecl", value}), do: MapSet.member?(@eyecolors, value)

  def valid?({"pid", value}), do: String.length(value) == 9 && Regex.match?(~r/[0-9]/, value)

  def valid?({"cid", _}), do: false

  def part1(input \\ readinput()) do
    input
    |> Enum.map(&Map.keys/1)
    |> Enum.map(&allkeys?/1)
    |> Enum.count(& &1)
  end

  def part2(input \\ readinput()) do
    input
    |> Enum.map(fn entry ->
      entry
      |> Enum.map(fn {k, v} -> if valid?({k, v}), do: k end)
      |> Enum.filter(& &1)
    end)
    |> Enum.map(&allkeys?/1)
    |> Enum.count(& &1)
  end
end
