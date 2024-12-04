defmodule Day3 do
  def run do
    regex = ~r/mul\((\d{1,3}),(\d{1,3})\)/
    input = IO.read(:stdio, :eof)

    result =
      Regex.scan(regex, input)
      |> Enum.map(fn [_, mul1, mul2] -> String.to_integer(mul1) * String.to_integer(mul2) end)
      |> Enum.sum()

    IO.puts("part1: #{result}")

    no_donts =
      String.split(input, "do()")
      |> Enum.map(fn do_first -> String.split(do_first, "don't()", parts: 2) |> hd() end)
      |> Enum.join()

    result_without_donts =
      Regex.scan(regex, no_donts)
      |> Enum.map(fn [_, mul1, mul2] -> String.to_integer(mul1) * String.to_integer(mul2) end)
      |> Enum.sum()

    IO.puts("part2: #{result_without_donts}")
  end
end

Day3.run()
