defmodule Day7 do
  def run do
    input =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [result, numbers] = String.split(line, ":", trim: true)
        result = String.to_integer(result)

        numbers =
          String.split(numbers, " ", trim: true)
          |> Enum.map(&String.to_integer/1)

        {result, numbers}
      end)

    input
    |> Enum.map(fn {result, numbers} ->
      (calculation_possible({result, numbers}) && result) || 0
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part1")
  end

  defp calculation_possible({result, numbers}) do
    numbers
    |> Enum.reverse()
    |> calculations()
    |> Enum.member?(result)
  end

  defp calculations([]), do: []
  defp calculations([last]), do: [last]

  defp calculations([first | rest]) do
    calculations(rest)
    |> Enum.map(fn result_rest -> [first * result_rest, first + result_rest] end)
    |> List.flatten()
  end
end

Day7.run()
