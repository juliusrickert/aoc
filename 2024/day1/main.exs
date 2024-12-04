defmodule Day1 do
  def run do
    # Creates an array of arrays
    # Each line is an array that contains an array of the two values on the line.
    input =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> String.split(line) end)

    left =
      input
      |> Enum.map(fn [left, _] -> String.to_integer(left) end)
      |> Enum.sort()

    right =
      input
      |> Enum.map(fn [_, right] -> String.to_integer(right) end)
      |> Enum.sort()

    values = Enum.zip(left, right)

    # part1
    total_distance =
      values
      |> Enum.map(fn {left, right} -> abs(left - right) end)
      |> Enum.sum()

    IO.puts("part1: #{total_distance}")

    # part2
    frequencies_right = Enum.frequencies(right)

    similarity_score =
      Enum.map(left, fn num -> num * (frequencies_right[num] || 0) end)
      |> Enum.sum()

    IO.puts("part2: #{similarity_score}")
  end
end

Day1.run()
