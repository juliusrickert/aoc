defmodule Day8 do
  def run do
    input =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    input
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.delete(?.)
    |> Map.keys()
    |> Enum.map(fn frequency ->
      locations(frequency, input)
      |> locations_to_antinodes(50, 50)
    end)
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.size()
    |> IO.inspect(label: "part1")
  end

  # locations returns the coordinates of all occurrences of the subject in the matrix.
  # Basically the starting_point function of day 6.
  defp locations(subject, matrix) do
    Enum.with_index(matrix, fn line, row ->
      Enum.with_index(line, fn element, col -> {row, col, element} end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {_, _, element} -> element == subject end)
    |> Enum.map(fn {row, col, _} -> {row, col} end)
  end

  defp locations_to_antinodes(locations, rows, cols) do
    pairings = for a <- locations, b <- locations, a < b, do: {a, b}

    antinode_candidates =
      Enum.map(pairings, fn {{row0, col0}, {row1, col1}} ->
        diff_row = row0 - row1
        diff_col = col0 - col1
        [{row0 + diff_row, col0 + diff_col}, {row1 - diff_row, col1 - diff_col}]
      end)
      |> List.flatten()

    # Filter out-of-bound & antenna locations
    Enum.filter(antinode_candidates, fn {row, col} ->
      row >= 0 && col >= 0 && row < rows && col < cols
    end)
    |> Enum.filter(fn element ->
      not Enum.member?(locations, element)
    end)
  end
end

Day8.run()