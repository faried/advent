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
          Map.update(newfish, 8, count, fn e -> e + count end)
          |> Map.update(6, count, fn e -> e + count end)

        _ ->
          Map.update(newfish, f - 1, count, fn e -> e + count end)
      end
    end)
    |> multiply2(days - 1)
  end
end
