defmodule Day06 do
  def part1(input) do
    input
    |> parse1()
    |> Enum.map(&race/1)
    |> Enum.product()
  end

  def part2(input) do
    input
    |> parse2()
    |> race()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp parse1([times, distances]) do
    timels =
      times
      |> String.replace("Time:", "")
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    distls =
      distances
      |> String.replace("Distance:", "")
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    Enum.zip(timels, distls)
  end

  defp parse2([times, distances]) do
    time =
      times
      |> String.replace("Time:", "")
      |> String.replace(" ", "")
      |> String.to_integer()

    dist =
      distances
      |> String.replace("Distance:", "")
      |> String.replace(" ", "")
      |> String.to_integer()

    {time, dist}
  end

  defp race({race_time, target_distance}) do
    Enum.reduce(0..race_time, 0, fn hold_time, wins ->
      move_time = race_time - hold_time
      distance = move_time * hold_time

      if distance > target_distance, do: wins + 1, else: wins
    end)
  end
end
