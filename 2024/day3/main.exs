defmodule Day3 do
  def run do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    input = IO.read(:stdio, :eof)

    result =
      Regex.scan(regex, input)
      |> Enum.map(fn [_, mul1, mul2] -> String.to_integer(mul1) * String.to_integer(mul2) end)
      |> Enum.sum()

    IO.puts("part1: #{result}")
  end
end

Day3.run()
