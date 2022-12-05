defmodule Day05 do
  @moduledoc """
  Documentation for `Day05`.
  """

  def part1({crates, commands}) do
    Enum.reduce(commands, crates, fn {count, from, to}, crates ->
      {take, remain} = Enum.split(crates[from], count)

      Map.put(crates, from, remain)
      |> Map.put(to, Enum.reverse(take) ++ crates[to])
    end)
    |> top_crates()
  end

  def part2({crates, commands}) do
    Enum.reduce(commands, crates, fn {count, from, to}, crates ->
      {take, remain} = Enum.split(crates[from], count)

      Map.put(crates, from, remain)
      |> Map.put(to, take ++ crates[to])
    end)
    |> top_crates()
  end

  def read_input(fname) do
    [crates, moves] =
      File.read!("priv/#{fname}")
      |> String.split("\n\n", trim: true)

    {to_map(crates), to_cmdlist(moves)}
  end

  defp to_map(crates) do
    String.split(crates, "\n", trim: true)
    |> Enum.flat_map(fn row ->
      String.graphemes(row)
      |> Enum.drop_every(2)
      |> Enum.with_index()
      |> Enum.filter(fn {crate, _} -> crate != " " end)
    end)
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn {crate, col}, cratesmap ->
      Map.update(cratesmap, div(col, 2) + 1, [crate], fn existing -> [crate | existing] end)
    end)
  end

  defp to_cmdlist(moves) do
    moves
    |> String.split("\n", trim: true)
    |> Enum.map(fn movestr ->
      [_, count, _, from, _, to] = String.split(movestr, " ", trim: true)
      {String.to_integer(count), String.to_integer(from), String.to_integer(to)}
    end)
  end

  defp top_crates(crates) do
    Map.keys(crates)
    |> Enum.sort()
    |> Enum.map(fn col -> hd(crates[col]) end)
    |> Enum.join("")
  end
end
