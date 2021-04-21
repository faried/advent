defmodule Day08.Console do
  def run(program, acc \\ 0, pc \\ 0, seenpc \\ MapSet.new())

  # ran off the end
  def run(program, acc, pc, _seenpc) when pc == length(program), do: {acc, true}

  def run(program, acc, pc, seenpc) do
    {instruction, moveorinc} = Enum.at(program, pc)

    {nextpc, newacc} =
      case instruction do
        "nop" -> {pc + 1, acc}
        "acc" -> {pc + 1, acc + moveorinc}
        "jmp" -> {pc + moveorinc, acc}
      end

    if nextpc in seenpc do
      {acc, false}
    else
      run(program, newacc, nextpc, MapSet.put(seenpc, nextpc))
    end
  end
end

defmodule Day08 do
  alias Day08.Console

  def readinput() do
    File.read!("8.input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [instruction, moveorinc] =
        line
        |> String.replace("+", "")
        |> String.split()

      {instruction, String.to_integer(moveorinc)}
    end)
  end

  def part1(program \\ readinput()) do
    Console.run(program)
    |> elem(0)
  end

  def part2(program \\ readinput()) do
    modify(program)
  end

  def modify(program, start \\ 0)

  def modify(program, start) when start == length(program), do: :error

  def modify(program, start) do
    # find first nop or jmp after start
    # if moveorinc is not 0, modify it
    # run the program
    # repeat until it ends with {_, true}

    searchprogram = Enum.slice(program, start, length(program))

    changepos =
      Enum.find_index(searchprogram, fn {instruction, moveorinc} ->
        instruction in ["nop", "jmp"] and moveorinc != 0
      end)

    {instruction, moveorinc} = Enum.at(program, changepos + start)

    newinstruction =
      case instruction do
        "jmp" -> "nop"
        "nop" -> "jmp"
      end

    newprogram = List.replace_at(program, changepos + start, {newinstruction, moveorinc})

    case Console.run(newprogram) do
      {acc, true} -> acc
      {_, false} -> modify(program, changepos + start + 1)
    end
  end
end
