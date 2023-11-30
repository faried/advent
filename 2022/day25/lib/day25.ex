defmodule Day25 do
  @moduledoc """
  Documentation for `Day25`.
  """

  def part1(input) do
    Enum.map(input, &snafu2dec/1)
    |> Enum.sum()
    |> dec2snafu()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp snafu2dec(snafunum, total \\ 0)

  defp snafu2dec(<<>>, total), do: total

  defp snafu2dec(<<s, rest::binary>>, total) do
    n =
      case s do
        ?2 -> 2
        ?1 -> 1
        ?0 -> 0
        ?- -> -1
        ?= -> -2
      end

    snafu2dec(rest, total * 5 + n)
  end

  defp dec2snafu(number, sofar \\ [])

  defp dec2snafu(0, sofar), do: Enum.join(sofar, "")

  defp dec2snafu(number, sofar) do
    digit = rem(number, 5)

    sdigit =
      case digit do
        0 -> "0"
        1 -> "1"
        2 -> "2"
        3 -> "="
        4 -> "-"
      end

    if digit > 2 do
      dec2snafu(div(number, 5) + 1, [sdigit | sofar])
    else
      dec2snafu(div(number, 5), [sdigit | sofar])
    end
  end
end
