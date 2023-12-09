defmodule Day08.Parser do
  import NimbleParsec

  position = ascii_string([?A..?Z], 3)
  left = ascii_string([?A..?Z], 3)
  right = ascii_string([?A..?Z], 3)

  input =
    position
    |> ignore(string(" = "))
    |> ignore(string("("))
    |> concat(left)
    |> ignore(string(", "))
    |> concat(right)
    |> ignore(string(")"))

  defparsec(:node, input)
end
