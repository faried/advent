defmodule Day03 do
  @moduledoc """
  Documentation for `Day03`.
  """

  @mul ~r/mul\((\d{1,3}),(\d{1,3})\)/
  @mul2 ~r/do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)/

  def part1(input) do
    Regex.scan(@mul, input)
    |> Enum.reduce(0, fn [_, a, b], acc ->
      ai = String.to_integer(a)
      bi = String.to_integer(b)

      acc + ai * bi
    end)
  end

  def part2(input) do
    Regex.scan(@mul2, input)
    |> Enum.reduce({0, true}, fn opls, {acc, scanning} ->
      case {hd(opls), scanning} do
        {"do()", _} ->
          {acc, true}

        {"don't()", _} ->
          {acc, false}

        {_, true} ->
          [_, a, b] = opls
          ai = String.to_integer(a)
          bi = String.to_integer(b)

          {acc + ai * bi, scanning}

        {_, false} ->
          {acc, scanning}
      end
    end)
    |> elem(0)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.join("")
  end
end
