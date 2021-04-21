defmodule Day19 do
  def readinput() do
    [rules, strings] =
      File.read!("19.test2.txt")
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))
    rulemap = Enum.map(rules, fn r ->
      String.split(r, ": ")
      |> List.to_tuple() end)
      |> Enum.into(%{})
    {rulemap, strings}
  end

  def chase(rulemap, r) do
    e = Map.get(rulemap, r)

    if String.starts_with?(e, "\"") do
      String.at(e, 1)
    else
      if String.contains?(e, " | ") do
        {:or, String.split(e, " | ")
        |> Enum.map(fn e1 -> Enum.map(String.split(e1), &chase(rulemap, &1)) end)}
        else
          Enum.map(String.split(e), &chase(rulemap, &1))
      end
    end
  end

  def match([_r|_rules], []), do: false
  def match([], []), do: true
  def match([], rest), do: IO.inspect(rest, label: "remainder"); false

  def match([r|rules], [s|rest]) when is_binary(r) do
    IO.puts("matching #{inspect(s)} against #{inspect(r)}")
    if r == s do
      IO.puts("matched #{s} against #{r}")
      match(rules, rest)
    else
      false
    end
  end

  def match([{:or, maybes}|rules], str) do
    IO.puts("match? {} #{inspect(str)} against #{inspect(maybes)}")
    maybematch = Enum.find(maybes, fn m -> match(m, str) end)
    if maybematch, do: match(rules, Enum.drop(str, length(maybematch))), else: false
  end

  def match([r|rules], str) when is_list(r) do
    match([hd(r)|rules], str)
  end

  def part1({rules, strings} \\ readinput()) do
    rule0 = chase(rules, "0")
    Enum.map(strings, &Day19.match(rule0, String.graphemes(&1)))
    |> Enum.count(& &1)
  end
end
