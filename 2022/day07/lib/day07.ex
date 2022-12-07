defmodule Day07 do
  @moduledoc """
  Documentation for `Day07`.
  """

  @minsize 100_000
  @total 70_000_000
  @wanted 30_000_000

  def part1(input) do
    walk(input)
    |> Map.values()
    |> Enum.reduce(0, fn dir, acc ->
      if dir.size < @minsize, do: acc + dir.size, else: acc
    end)
  end

  def part2(input) do
    dirmap = walk(input)
    diskused = dirmap["/"].size
    free = @total - diskused

    Map.values(dirmap)
    |> Enum.sort(fn a, b -> a.size < b.size end)
    |> Enum.find(fn dir -> free + dir.size >= @wanted end)
    |> Map.get(:size)
  end

  defp walk(["$ cd /" | rest]) do
    root = Day07.Dir.new("/", nil)

    walk(rest, root, %{"/" => root})
  end

  defp walk([], curdir, dirmap) do
    # if we are not in /, we need to update parent sizes all the way
    # to the root
    if curdir.cur != "/" do
      # fake it
      walk(["$ cd .."], curdir, dirmap)
    else
      dirmap
    end
  end

  # before moving up the tree, update the parent's size to include our
  # size
  defp walk(["$ cd .." | rest], curdir, dirmap) do
    parent =
      dirmap[curdir.parent]
      |> Day07.Dir.add_subdir_size(curdir.size)

    newmap =
      Map.put(dirmap, curdir.cur, curdir)
      |> Map.put(curdir.parent, parent)

    walk(rest, parent, newmap)
  end

  defp walk(["$ cd " <> dirname | rest], curdir, dirmap) do
    dirpath = Path.join(curdir.cur, dirname)
    newdir = Day07.Dir.new(dirpath, curdir.cur)

    newmap =
      Map.put(dirmap, curdir.cur, curdir)
      |> Map.put(dirpath, newdir)

    walk(rest, newdir, newmap)
  end

  # skip
  defp walk(["$ ls" | rest], curdir, dirmap) do
    walk(rest, curdir, dirmap)
  end

  # skip
  defp walk(["dir" <> _dirname | rest], curdir, dirmap) do
    walk(rest, curdir, dirmap)
  end

  # dirmap is updated lazily when we change directories
  defp walk([entry | rest], curdir, dirmap) do
    curdir = Day07.Dir.add_file(curdir, entry)

    walk(rest, curdir, dirmap)
  end

  def read_input(fname) do
    File.read!("priv/#{fname}")
    |> String.split("\n", trim: true)
  end
end
