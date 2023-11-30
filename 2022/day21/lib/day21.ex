defmodule Day21 do
  @moduledoc """
  Documentation for `Day21`.
  """

  def part1(input) do
    to_tree(input)
    |> expand1("root")
  end

  def part2(input) do
    to_tree(input)
    |> expand2("root")
  end

  def to_tree(lines) do
    Enum.reduce(lines, %{}, fn line, tree ->
      [lhs, rhs] = String.split(line, ": ")
      if String.contains?(rhs, " ") do
        [left, op, right] = String.split(rhs, " ", trim: true)
        Map.put(tree, lhs, [left, op, right])
      else
        Map.put(tree, lhs, String.to_integer(rhs))
      end
    end)
  end

  def expand1(tree, from) do
    exp = Map.get(tree, from)
    if is_integer(exp) do
      exp
    else
      [left, op, right] = exp
      expleft = expand1(tree, left)
      expright = expand1(tree, right)
      case op do
        "+" -> expleft + expright
        "-" -> expleft - expright
        "/" -> div(expleft, expright)
        "*" -> expleft * expright
      end
    end
  end

  def expand2(_tree, "humn"), do: "humn"

  def expand2(tree, "root") do
    [left, _, right] = Map.get(tree, "root")
    expleft = expand2(tree, left)
    expright = expand2(tree, right)

    expleft = cond do
      is_integer(expleft) -> expleft
      String.contains?(expleft, "humn") -> expleft
      true -> Code.eval_string(expright, [], __ENV__) |> elem(0)
    end

    expright = cond do
      is_integer(expright) -> expright
      String.contains?(expright, "humn") -> expright
      true -> Code.eval_string(expright, [], __ENV__) |> elem(0)
    end

    IO.puts("solve(#{expleft} = #{expright}, [humn]);")
    # if is_integer(expleft), do: {expleft, expright}, else: {expright, expleft}
  end

  def expand2(tree, from) do
    exp = Map.get(tree, from)
    cond do
      is_integer(exp) -> exp
      is_list(exp) ->
        [left, op, right] = exp

        expleft = expand2(tree, left)
        expright = expand2(tree, right)

        # simplify if possible: trying to avoid expressions
        # like (4) * (2)
        cond do
          is_integer(expleft) and is_integer(expright) ->
            case op do
              "+" -> expleft + expright
              "-" -> expleft - expright
              "/" -> div(expleft, expright)
              "*" -> expleft * expright
            end
          is_integer(expleft) ->
            case op do
              "+" -> "#{expleft} + #{expright}"
              "-" -> "#{expleft} - #{expright}"
              "/" -> "#{expleft} / (#{expright})"
              "*" -> "#{expleft} * (#{expright})"
            end
          is_integer(expright) ->
            case op do
              "+" -> "#{expleft} + #{expright}"
              "-" -> "#{expleft} - #{expright}"
              "/" -> "(#{expleft}) / #{expright}"
              "*" -> "(#{expleft}) * #{expright}"
            end
          true ->
            case op do
              "+" -> "#{expleft} + #{expright}"
              "-" -> "#{expleft} - #{expright}"
              "/" -> "(#{expleft}) / (#{expright})"
              "*" -> "(#{expleft}) * (#{expright})"
            end
        end
    end
  end


  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end
end
