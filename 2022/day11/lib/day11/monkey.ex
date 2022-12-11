defmodule Day11.Monkey do
  @moduledoc """
  Documentation for `Day11.Monkey`.
  """

  alias __MODULE__

  defstruct number: -1, items: [], opfn: nil, nextfn: nil, modby: 0, inspected: 0

  def new(monkeystr) do
    [numstr, startstr, opstr, teststr, truestr, falsestr] =
      monkeystr
      |> String.split("\n", trim: true)
      |> Enum.map(&String.trim/1)

    number =
      Regex.run(~r/Monkey (\d+):/, numstr)
      |> Enum.at(1)
      |> String.to_integer()

    items =
      String.split(startstr, ": ")
      |> Enum.at(1)
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)

    body =
      opstr
      |> String.split(" = ")
      |> Enum.at(1)

    opfnstr = "fn old -> #{body} end"
    {opfn, _} = Code.eval_string(opfnstr, [], __ENV__)

    modby =
      teststr
      |> String.split("by ")
      |> Enum.at(1)
      |> String.to_integer()

    true_monkey =
      truestr
      |> String.split("monkey ")
      |> Enum.at(1)
      |> String.to_integer()

    false_monkey =
      falsestr
      |> String.split("to monkey ")
      |> Enum.at(1)
      |> String.to_integer()

    testfnstr =
      "fn num -> if rem(num, #{modby}) == 0, do: #{true_monkey}, else: #{false_monkey} end"

    {nextfn, _} = Code.eval_string(testfnstr, [], __ENV__)

    %Monkey{number: number, items: items, opfn: opfn, nextfn: nextfn, modby: modby}
  end

  def round(%Monkey{} = monkey, mod \\ nil, divide \\ true) do
    moves =
      Enum.reduce(monkey.items, [], fn item, actions ->
        worry =
          monkey.opfn.(item)
          |> Kernel.then(fn worry -> if mod, do: rem(worry, mod), else: worry end)
          |> Kernel.then(fn worry -> if divide, do: div(worry, 3), else: worry end)

        [{monkey.nextfn.(worry), worry} | actions]
      end)

    {moves, %{monkey | inspected: monkey.inspected + Enum.count(monkey.items), items: []}}
  end

  def add_items(%Monkey{} = monkey, items) do
    %{monkey | items: monkey.items ++ items}
  end
end
