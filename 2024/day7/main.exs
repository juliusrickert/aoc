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

    input
    |> Enum.map(fn {result, numbers} ->
      (calculation_possible({result, numbers}, true) && result) || 0
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part2")
  end

  defp calculation_possible({result, numbers}, allow_concat? \\ false) do
    numbers
    |> Enum.reverse()
    |> calculations(allow_concat?)
    |> Enum.member?(result)
  end

  defp calculations([], _), do: []
  defp calculations([last], _), do: [last]

  defp calculations([first | rest], allow_concat?) do
    calculations(rest, allow_concat?)
    |> Enum.map(fn result_rest ->
      [first * result_rest, first + result_rest] ++
        ((allow_concat? &&
            [reversed_concat([first, result_rest])]) || [])
    end)
    |> List.flatten()
  end

  defp reversed_concat(list) do
    list
    |> Enum.reverse()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end
end

Day7.run()
