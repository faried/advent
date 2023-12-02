defmodule Day02 do
  @max_red 12
  @max_green 13
  @max_blue 14
  @empty_game_map %{"red" => 0, "blue" => 0, "green" => 0}

  def part1(input) do
    Enum.reduce(input, 0, fn game, id_sum ->
      {game_id, cubes} = parse_game(game)

      if ok_game?(cubes), do: id_sum + game_id, else: id_sum
    end)
  end

  def part2(input) do
    Enum.reduce(input, 0, fn game, power_sum ->
      {_, cubes} = parse_game(game)

      power_sum + cubes["red"] * cubes["blue"] * cubes["green"]
    end)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end

  defp parse_game(game_line) do
    [lhs, rhs] = String.split(game_line, ": ")

    game_id =
      lhs
      |> String.replace("Game ", "")
      |> String.to_integer()

    num_cubes =
      rhs
      |> String.split("; ")
      |> max_cubes()

    {game_id, num_cubes}
  end

  defp max_cubes(rounds) do
    # "3 blue, 2 red" => [{"blue", 3}, {"red", 2}]
    # Map.new(ls) gives us one map with everything:
    # %{"blue" => 3, "red" => 2}

    Enum.reduce(rounds, @empty_game_map, fn round, max_map ->
      round
      |> String.split(", ")
      |> Enum.map(fn cube_count ->
        [countstr, color] = String.split(cube_count, " ")

        {color, String.to_integer(countstr)}
      end)
      |> Map.new()
      |> Map.merge(max_map, fn _k, v1, v2 -> max(v1, v2) end)
    end)
  end

  defp ok_game?(cubes) do
    cubes["red"] <= @max_red and cubes["blue"] <= @max_blue and cubes["green"] <= @max_green
  end
end
