defmodule Day16 do
  def readinput() do
    [labelranges, myticket, nearbytickets] =
      File.read!("16.input.txt")
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n", trim: true))

    # my ticket and nearby ticket sections starts with a header string
    # use tl() to skip that
    [
      ranges(labelranges),
      ticketsplit(List.last(myticket)),
      Enum.map(tl(nearbytickets), &ticketsplit/1)
    ]
  end

  @doc """
  Takes a list of strings like

  ["class: 1-3 or 5-7", "row: 6-11 or 33-44", "seat: 13-40 or 45-50"]

  and returns a dictionary of string keys, list of ranges values

    %{
        "class" => [1..3, 5..7],
        "row" => [6..11, 33..44],
        "seat" => [13..40, 45..50]
      },
  """
  def ranges(labels) do
    labels
    |> Enum.map(fn rule ->
      [label, r1start, r1end, r2start, r2end] =
        Regex.run(~r/(.*): (\d+)-(\d+) or (\d+)-(\d+)/, rule, capture: :all_but_first)

      {label,
       [
         String.to_integer(r1start)..String.to_integer(r1end),
         String.to_integer(r2start)..String.to_integer(r2end)
       ]}
    end)
    |> Map.new()
  end

  @doc """
  Splits a comma-separated list of numbers as a string and
  returns a list of numbers.
  """
  def ticketsplit(ticket) do
    String.split(ticket, ",")
    |> Enum.map(&String.to_integer/1)
  end

  def part1([rangemap, _, nearbytickets] \\ readinput()) do
    allranges = Map.values(rangemap) |> List.flatten()

    Enum.flat_map(nearbytickets, fn ticket ->
      Enum.reject(ticket, fn field ->
        Enum.any?(allranges, fn range ->
          field in range
        end)
      end)
    end)
    |> Enum.sum()
  end

  ################ part 2 ################

  def part2([rangemap, myticket, nearbytickets] \\ readinput()) do
    allranges = Map.values(rangemap) |> List.flatten()

    validtickets =
      Enum.filter(nearbytickets, fn ticket ->
        length(ticket) ==
          Enum.filter(ticket, fn field ->
            Enum.any?(allranges, fn range ->
              field in range
            end)
          end)
          |> Enum.count()
      end)
      |> Enum.map(&fieldtolabel(&1, rangemap))

    numtickets = length(validtickets)

    # labels starting with "departure"
    departuresidx =
      process(validtickets, numtickets)
      |> Enum.reduce([], fn {idx, label}, acc ->
        if String.starts_with?(label, "departure"), do: [idx | acc], else: acc
      end)

    # finally, calculate the product of the departure fields in my ticket
    myticket
    |> Enum.with_index()
    |> Enum.reduce(1, fn {val, idx}, acc ->
      if idx in departuresidx, do: acc * val, else: acc
    end)
  end

  @doc """

  Take a list of tickets and return a list of matching labels against
  each ticket item.  Find the matching labels by checking every item in
  each ticket with the label ranges.
  """
  def fieldtolabel(ticket, rangemap, result \\ [])

  def fieldtolabel([], _, result), do: Enum.reverse(result)

  def fieldtolabel([t | ticket], rangemap, result) do
    labels =
      Enum.filter(rangemap, fn {_label, [r1, r2]} ->
        t in r1 or t in r2
      end)
      |> Enum.map(fn {k, _v} -> k end)

    fieldtolabel(ticket, rangemap, [labels | result])
  end

  @doc """
  Take something like

    [
      [["row", "seat"], ["class", "row", "seat"], ["class", "row", "seat"]],
      [["class", "row"], ["class", "row", "seat"], ["class", "row", "seat"]],
      [["class", "row", "seat"], ["class", "row"], ["class", "row", "seat"]]
    ]

  and rotate it so the first column becomes the first row, etc.  Then, flatten the
  list:

    [["row", "seat"], ["class", "row"], ["class", "row", "seat"]]
    [["class", "row", "seat"], ["class", "row", "seat"], ["class", "row"]]
    [["class", "row", "seat"], ["class", "row", "seat"], ["class", "row", "seat"]]

    =>

    ["row", "seat", "class", "row", "class", "row", "seat"]
    ["class", "row", "seat", "class", "row", "seat", "class", "row"]
    ["class", "row", "seat", "class", "row", "seat", "class", "row", "seat"]

  Calculate the frequency of each item in each row, and filter out all
  items that do not show up in all of the original table's columns.
  We are left with the common fields.

  [["row"], ["class", "row"], ["class", "row", "seat"]]
  """
  def process(validtickets, numtickets) do
    # next time, use Enum.zip
    bycolumn =
      for c <- 0..(length(List.first(validtickets)) - 1) do
        for r <- 0..(numtickets - 1) do
          Enum.at(validtickets, r) |> Enum.at(c)
        end
        |> List.flatten()
        |> Enum.frequencies()
        |> Enum.filter(fn {_k, v} -> v == numtickets end)
        |> Enum.map(fn {k, _v} -> k end)
      end
      |> Enum.with_index()

    # take something like [{["seat"], 0}]
    # and convert it to %{0 => "seat"}

    # "seat" is the common field in the first item of each row of validtickets

    colmap =
      bycolumn
      |> Enum.filter(fn {ks, _c} -> length(ks) == 1 end)
      |> Enum.reduce(%{}, fn {k, c}, acc -> Map.put(acc, c, List.first(k)) end)

    loop(colmap, bycolumn)
  end

  @doc """
  Loop until each column in bycolumn has one label
  """
  def loop(colmap, bycolumn) do
    if Enum.all?(bycolumn, fn {ks, _c} -> length(ks) == 1 end) do
      colmap
    else
      bycolumn =
        Enum.map(bycolumn, fn {ks, c} ->
          if length(ks) == 1 do
            {ks, c}
          else
            {MapSet.new(ks)
             |> MapSet.difference(MapSet.new(Map.values(colmap)))
             |> MapSet.to_list(), c}
          end
        end)

      colmap =
        bycolumn
        |> Enum.filter(fn {ks, _c} -> length(ks) == 1 end)
        |> Enum.reduce(%{}, fn {k, c}, acc -> Map.put(acc, c, List.first(k)) end)

      loop(colmap, bycolumn)
    end
  end
end
