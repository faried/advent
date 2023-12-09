defmodule Day08 do
  alias Day08.Parser

  def part1({instructions, nodes}) do
    walk(instructions, nodes, &(&1 == "ZZZ"), "AAA", 0)
    |> elem(1)
  end

  def part2({instructions, nodes}) do
    nodes
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn starting_node ->
      walk(instructions, nodes, &String.ends_with?(&1, "Z"), starting_node, 0)
      |> elem(1)
    end)
    |> lcm()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> parse()
  end

  defp parse([instructions | input]) do
    {String.split(instructions, "", trim: true),
     input
     |> Enum.reduce(%{}, fn line, acc ->
       {:ok, [position, left, right], "", _, _, _} = Parser.node(line)
       Map.put(acc, position, {left, right})
     end)}
  end

  defp walk(instructions, nodes, endfn, current_node, steps_taken) do
    {end_node, steps_taken} =
      Enum.reduce_while(instructions, {current_node, steps_taken}, fn ins,
                                                                      {current_node, steps_taken} ->
        new_node = step(ins, nodes, current_node)

        if endfn.(new_node) do
          {:halt, {new_node, steps_taken + 1}}
        else
          {:cont, {new_node, steps_taken + 1}}
        end
      end)

    # either we found the end node or we ran out of instructions
    if endfn.(end_node) do
      {end_node, steps_taken}
    else
      walk(instructions, nodes, endfn, end_node, steps_taken)
    end
  end

  defp step(instruction, nodes, current_node) do
    next = nodes[current_node]

    if instruction == "L", do: elem(next, 0), else: elem(next, 1)
  end

  defp lcm(nums) do
    Enum.reduce(nums, fn a, b -> trunc(a * b / Integer.gcd(a, b)) end)
  end
end
