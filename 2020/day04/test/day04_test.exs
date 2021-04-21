defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  test "values" do
    assert Day04.valid?({"byr", "2002"})
    assert !Day04.valid?({"byr", "2003"})

    assert Day04.valid?({"hgt", "60in"})
    assert Day04.valid?({"hgt", "190cm"})
    assert !Day04.valid?({"hgt", "190in"})
    assert !Day04.valid?({"hgt", "190"})

    assert Day04.valid?({"hcl", "#123abc"})
    assert !Day04.valid?({"hcl", "#123abz"})
    assert !Day04.valid?({"hcl", "123abc"})

    assert Day04.valid?({"ecl", "brn"})
    assert !Day04.valid?({"ecl", "wat"})

    assert Day04.valid?({"pid", "000000001"})
    assert !Day04.valid?({"pid", "0123456789"})
  end
end
