defmodule Day07 do
  @moduledoc """
  Documentation for `Day07`.
  """

  def part1(input), do: doit(input, &calibrate1/2)

  def part2(input), do: doit(input, &calibrate2/2)

  def doit(input, calibrate_fn) do
    Enum.reduce(input, 0, fn {target, numbers}, acc ->
      if calibrate_fn.(target, numbers), do: acc + target, else: acc
    end)
  end

  def calibrate1(target, [target]), do: true

  def calibrate1(target, [a, b | rest]) do
    calibrate1(target, [a + b | rest]) or calibrate1(target, [a * b | rest])
  end

  def calibrate1(_, _), do: false

  def calibrate2(target, [target]), do: true

  def calibrate2(target, [a, b | rest]) do
    # based on https://i.redd.it/0boww2vl8d5e1.jpeg
    calibrate2(target, [a + b | rest]) or calibrate2(target, [a * b | rest]) or
      calibrate2(target, [trunc(a * 10 ** :math.ceil(:math.log10(b + 1))) + b | rest])
  end

  def calibrate2(_, _), do: false

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [target, numbers] = String.split(line, ": ")

      {String.to_integer(target),
       numbers
       |> String.split()
       |> Enum.map(&String.to_integer/1)}
    end)
  end
end
