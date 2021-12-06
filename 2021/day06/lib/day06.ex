defmodule Day06 do
  @moduledoc """
  Documentation for `Day06`.
  """

  def multiply(fish, days) do
    Enum.frequencies(fish)
    |> multiply2(days)
  end

  defp multiply2(fish, 0), do: Map.values(fish) |> Enum.sum()

  defp multiply2(fish, days) do
    Enum.reduce(fish, %{}, fn {f, count}, newfish ->
      case f do
        0 ->
          Map.put(newfish, 8, count)
          |> Map.put(6, count)

        _ ->
          Map.update(newfish, f - 1, count, fn e -> e + count end)
      end
    end)
    |> multiply2(days - 1)
  end
end
