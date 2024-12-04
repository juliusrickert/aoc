defmodule Day2 do
  def run do
    # Creates an array of arrays
    # Each line is an array that contains an array of the two values on the line.
    input =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> Enum.map(fn item -> String.to_integer(item) end)
      end)

    is_safe =
      input
      |> Enum.map(&safe?/1)
      |> Enum.count(fn x -> x == true end)

    IO.puts("part1: #{is_safe}")
  end

  defp safe?(list) do
    monotonic?(list) and delta_ok?(list)
  end

  defp delta_ok?(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [left, right] ->
      delta = abs(left - right)
      1 <= delta and delta <= 3
    end)
  end

  defp monotonic?(list) do
    increasing =
      Enum.chunk_every(list, 2, 1, :discard) |> Enum.all?(fn [left, right] -> left < right end)

    decreasing =
      Enum.chunk_every(list, 2, 1, :discard) |> Enum.all?(fn [left, right] -> left > right end)

    increasing or decreasing
  end
end

Day2.run()
