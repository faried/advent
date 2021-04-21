defmodule Day01 do
  def readinput() do
    File.stream!("1.input.txt")
    |> Enum.map(fn numstr -> numstr |> String.trim() |> String.to_integer() end)
  end

  def part1(numbers \\ readinput()) do
    find2020_2(numbers, tl(numbers))
  end

  def part2(numbers \\ readinput()) do
    find2020_3(numbers, tl(numbers), tl(tl(numbers)))
  end

  defp find2020_2(numbers, []) when tl(numbers) == [], do: :barf

  defp find2020_2(numbers, []), do: find2020_2(tl(numbers), tl(tl(numbers)))

  defp find2020_2([n1 | _nums1] = numbers, [n2 | nums2]) do
    if n1 + n2 == 2020, do: n1 * n2, else: find2020_2(numbers, nums2)
  end

  defp find2020_3(numbers, [], []) when length(numbers) < 3, do: :barf

  defp find2020_3(numbers, [], []),
    do: find2020_3(tl(numbers), tl(tl(numbers)), tl(tl(tl(numbers))))

  defp find2020_3(numbers1, numbers2, []) when tl(numbers2) == [], do: find2020_3(numbers1, [], [])

  defp find2020_3(numbers1, numbers2, []), do: find2020_3(numbers1, tl(numbers2), tl(tl(numbers2)))

  defp find2020_3([n1 | _nums1] = numbers1, [n2 | _num2] = numbers2, [n3 | nums3]) do
    if n1 + n2 + n3 == 2020, do: n1 * n2 * n3, else: find2020_3(numbers1, numbers2, nums3)
  end

  # idea from mexicat in elixirforum
  def part1f(numbers \\ readinput()) do
    try do
      for a <- numbers,
        b <- tl(numbers),
        a + b == 2020,
        do: throw({:done, [a, b]})
    catch
      {:done, [a, b]} -> a * b
    end
  end

  def part2f(numbers \\ readinput()) do
    try do
      for a <- numbers,
        b <- tl(numbers),
        c <- tl(tl(numbers)),
        a + b + c == 2020,
        do: throw({:done, [a, b, c]})
    catch
      {:done, [a, b, c]} -> a * b * c
    end
  end
end

numbers = Day01.readinput()

IO.inspect(:timer.tc(Day01, :part1, [numbers]))
IO.inspect(:timer.tc(Day01, :part1f, [numbers]))

IO.inspect(:timer.tc(Day01, :part2, [numbers]))
IO.inspect(:timer.tc(Day01, :part2f, [numbers]))
