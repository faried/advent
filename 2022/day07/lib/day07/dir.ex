defmodule Day07.Dir do
  defstruct cur: "", parent: nil, size: 0

  def new(cur, parent) do
    %__MODULE__{cur: cur, parent: parent}
  end

  def add_file(%__MODULE__{} = dir, file_entry) do
    [size, _] = String.split(file_entry, " ", parts: 2)

    Map.update!(dir, :size, fn existing -> String.to_integer(size) + existing end)
  end

  def add_subdir_size(%__MODULE__{} = dir, size) do
    Map.update!(dir, :size, fn existing -> existing + size end)
  end
end
