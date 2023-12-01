defmodule Day01 do
  @moduledoc """
  Documentation for `Day01`.
  """

  @nums MapSet.new(0..9, &Integer.to_string/1)
  @num_map %{
    "zero" => "0",
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def part1(input) do
    Enum.map(input, &text_to_value1/1)
    |> Enum.sum()
  end

  def part2(input) do
    Enum.map(input, &text_to_value2/1)
    |> Enum.sum()
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp text_to_value1(text) do
    explode(text)
    |> Enum.filter(fn maybe_num -> maybe_num in @nums end)
    |> list_to_number()
  end

  defp text_to_value2(text), do: text_to_value2(text, [])

  defp text_to_value2("", acc) do
    Enum.reverse(acc)
    |> list_to_number()
  end

  defp text_to_value2(text, acc) do
    {next, maybe_nums} =
      Enum.reduce(@num_map, {text, []}, fn {num_word, num}, {line, collected} ->
        if String.starts_with?(line, num_word) or String.starts_with?(line, num) do
          {rest(line), [num | collected]}
        else
          {line, collected}
        end
      end)

    if maybe_nums == [] do
      text_to_value2(rest(next), acc)
    else
      text_to_value2(next, maybe_nums ++ acc)
    end
  end

  defp list_to_number(num_list) do
    (List.first(num_list) <> List.last(num_list))
    |> String.to_integer()
  end

  # helpers
  defp explode(str), do: String.split(str, "", trim: true)
  defp rest(str), do: String.slice(str, 1..-1)
end
