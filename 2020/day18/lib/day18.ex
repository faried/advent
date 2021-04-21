defmodule Day18 do
  def readinput() do
    File.read!("18.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&split/1)
  end

  def split(s) do
    s
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split()
  end

  def part1(input \\ readinput()) do
    Enum.reduce(input, 0, fn line, acc -> acc + parse(line, &eval1/2) end)
  end

  def part2(input \\ readinput()) do
    Enum.reduce(input, 0, fn line, acc -> acc + parse(line, &eval2/2) end)
  end

  ######## parse

  def parse(input, evalfn, result \\ [])

  def parse([], evalfn, result), do: evalfn.(Enum.reverse(result), nil)

  def parse(["+" | rest], evalfn, result), do: parse(rest, evalfn, [:add | result])
  def parse(["*" | rest], evalfn, result), do: parse(rest, evalfn, [:mult | result])

  def parse(["(" | rest], evalfn, result) do
    {unprocessed, inner} = parse(rest, evalfn)
    parse(unprocessed, evalfn, [inner | result])
  end

  def parse([")" | rest], evalfn, result) do
    {rest, evalfn.(Enum.reverse(result), nil)}
  end

  def parse([term | rest], evalfn, result),
    do: parse(rest, evalfn, [String.to_integer(term) | result])

  ######## eval for part 1

  def eval1(terms, op, out \\ 0)

  def eval1([], _, out), do: out

  def eval1([number | rest], :add, out), do: eval1(rest, nil, number + out)
  def eval1([number | rest], :mult, out), do: eval1(rest, nil, number * out)

  def eval1([term | rest], nil, out) do
    case term do
      :add -> eval1(rest, :add, out)
      :mult -> eval1(rest, :mult, out)
      _ -> eval1(rest, nil, term)
    end
  end

  ######## eval for part 2

  def eval2(terms, op, out \\ [])

  def eval2([], _, out), do: mult(out)

  def eval2([term | rest], :add, [first | left]) do
    eval2(rest, nil, [mult(first) + mult(term) | left])
  end

  def eval2([term | rest], nil, left) do
    case term do
      :add -> eval2(rest, :add, left)
      _ -> eval2(rest, nil, [term | left])
    end
  end

  def mult(thing) when is_number(thing), do: thing

  def mult(thing) when is_list(thing) do
    Enum.reject(thing, &(&1 == :mult))
    |> Enum.reduce(1, &Kernel.*/2)
  end
end
