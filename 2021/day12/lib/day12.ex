defmodule Day12 do
  @moduledoc """
  Documentation for `Day12`.
  """

  def part1(input) do
    paths =
      input
      |> String.split("\n", trim: true)
      |> build_paths(%{})

    Enum.reduce(paths["start"], 0, fn nextcave, acc ->
      acc + untilend(paths, nextcave, ["start"])
    end)
  end

  def part2(input) do
    paths =
      input
      |> String.split("\n", trim: true)
      |> build_paths(%{})

    Enum.reduce(paths["start"], 0, fn nextcave, acc ->
      acc + untilend(paths, nextcave, ["start"], %{})
    end)
  end

  defp untilend(paths, cave, sofar) do
    sofar = [cave | sofar]

    if cave == "end" do
      1
    else
      Enum.reduce(paths[cave], 0, fn nextcave, acc ->
        cond do
          nextcave == "start" -> acc
          nextcave in sofar and all_lower?(nextcave) -> acc
          true -> acc + untilend(paths, nextcave, sofar)
        end
      end)
    end
  end

  defp untilend(paths, cave, sofar, small_visited) do
    sofar = [cave | sofar]

    small_visited =
      if all_lower?(cave) do
        Map.update(small_visited, cave, 1, &(&1 + 1))
      else
        small_visited
      end

    if cave == "end" do
      1
    else
      Enum.reduce(paths[cave], 0, fn nextcave, acc ->
        cond do
          nextcave == "start" ->
            acc

          nextcave in sofar and all_lower?(nextcave) and
              Enum.any?(Map.values(small_visited), &(&1 > 1)) ->
            # already visited more than once
            acc

          true ->
            acc + untilend(paths, nextcave, sofar, small_visited)
        end
      end)
    end
  end

  defp all_lower?(cave), do: cave == String.downcase(cave)

  defp build_paths([], m), do: m

  defp build_paths([path | paths], m) do
    [s, e] = String.split(path, "-")

    newm =
      Map.update(m, s, [e], fn existing -> [e | existing] end)
      |> Map.update(e, [s], fn existing -> [s | existing] end)

    build_paths(paths, newm)
  end
end
