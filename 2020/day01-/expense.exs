defmodule Day01 do
  def readinput() do
    File.stream!("1.input.txt")
    |> Enum.map(fn numstr -> numstr |> String.trim() |> String.to_integer() end)
  end

  def part1() do
    numbers = readinput()
    find2020(numbers, tl(numbers))
  end

  def part2() do
    numbers = readinput()
    find2020_3(numbers, tl(numbers), tl(tl(numbers)))
  end

  def find2020(numbers, []), do: find2020(tl(numbers), tl(tl(numbers)))

  def find2020([n1 | _nums1] = numbers, [n2 | nums2]) do
    if n1 + n2 == 2020, do: n1 * n2, else: find2020(numbers, nums2)
  end

  def find2020_3(numbers, [], []),
    do: find2020_3(tl(numbers), tl(tl(numbers)), tl(tl(tl(numbers))))

  def find2020_3(numbers1, numbers2, []) when tl(numbers2) == [], do: find2020_3(numbers1, [], [])

  def find2020_3(numbers1, numbers2, []), do: find2020_3(numbers1, tl(numbers2), tl(tl(numbers2)))

  def find2020_3([n1 | _nums1] = numbers1, [n2 | _num2] = numbers2, [n3 | nums3]) do
    if n1 + n2 + n3 == 2020, do: n1 * n2 * n3, else: find2020_3(numbers1, numbers2, nums3)
  end

  def part2x() do
    numbers = readinput()
    {a, b, c} = Enum.find_value(numbers, fn i -> three_adds_to_2020(i, numbers) end)
    {{a, b, c}, a * b * c}
  end

  defp three_adds_to_2020([i, j], list) do
    Enum.find_value(list, fn k -> if(i + j + k == 2020, do: {i, j, k}) end)
  end

  defp three_adds_to_2020(i, list) do
    Enum.find_value(list, fn j -> three_adds_to_2020([i, j], list) end)
  end

end

IO.puts("part 1 #{Day01.part1()}")
IO.puts("part 2 #{Day01.part2()}")
IO.puts("part 2x #{inspect(Day01.part2x())}")
