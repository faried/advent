defmodule Day17 do
  def readinput() do
    File.read!("17.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def neighbors3({x, y, z}) do
    for i <- -1..1 do
      for j <- -1..1 do
        for k <- -1..1 do
          {x + i, y + j, z + k}
        end
      end
    end
    |> List.flatten()
    # we have to return the neighbors of a point, so we explicitly
    # remove the point from the output
    |> Enum.reject(fn {a, b, c} -> a == x and b == y and c == z end)
  end

  def neighbors4({x, y, z, w}) do
    for i <- -1..1 do
      for j <- -1..1 do
        for k <- -1..1 do
          for l <- -1..1 do
            {x + i, y + j, z + k, w + l}
          end
        end
      end
    end
    |> List.flatten()
    |> Enum.reject(fn {a, b, c, d} -> a == x and b == y and c == z and d == w end)
  end

  def activeneighbors(state, neighborfn, point) do
    Enum.count(neighborfn.(point), &Map.has_key?(state, &1))
  end

  def cycle(state, _, 0) do
    state
    |> Map.values()
    |> Enum.count(fn cell -> cell == "#" end)
  end

  def cycle(state, neighborfn, count) do
    # find the neighbors of active cells
    tocheck =
      state
      |> Map.keys()
      |> Enum.flat_map(neighborfn)
      |> Enum.frequencies()

    Enum.map(tocheck, fn {point, _} ->
      cell = Map.get(state, point)
      countactive = activeneighbors(state, neighborfn, point)

      cond do
        cell == "#" and countactive not in [2, 3] -> {point, :inactive}
        countactive == 3 -> {point, :active}
        true -> nil
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.reduce(state, fn {p, newstate}, acc ->
      case newstate do
        :inactive -> Map.delete(acc, p)
        :active -> Map.put(acc, p, "#")
      end
    end)
    # why does this happen?
    |> Enum.reject(fn {point, _} -> !Map.get(tocheck, point) end)
    |> Map.new()
    |> cycle(neighborfn, count - 1)
  end

  def part1(input \\ readinput()) do
    rows = length(input)
    cols = length(Enum.at(input, 0))

    for c <- 0..(cols - 1) do
      for r <- 0..(rows - 1) do
        {{c, r, 0}, Enum.at(input, r) |> Enum.at(c)}
      end
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.into(%{})
    end
    # i don't like this
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)
    |> cycle(&neighbors3/1, 6)
  end

  def part2(input \\ readinput()) do
    rows = length(input)
    cols = length(Enum.at(input, 0))

    for c <- 0..(cols - 1) do
      for r <- 0..(rows - 1) do
        {{c, r, 0, 0}, Enum.at(input, r) |> Enum.at(c)}
      end
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.into(%{})
    end
    # i don't like this
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m) end)
    |> cycle(&neighbors4/1, 6)
  end
end
