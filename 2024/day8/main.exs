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

    input
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.delete(?.)
    |> Map.keys()
    |> Enum.map(fn frequency ->
      locations(frequency, input)
      |> locations_to_antinodes(50, 50, true)
    end)
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.size()
    |> IO.inspect(label: "part2")
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

  defp locations_to_antinodes(locations, rows, cols, part2 \\ false) do
    pairings = for a <- locations, b <- locations, a < b, do: {a, b}

    antinode_candidates =
      unless part2 do
        Enum.map(pairings, fn {{row0, col0}, {row1, col1}} ->
          diff_row = row0 - row1
          diff_col = col0 - col1
          [{row0 + diff_row, col0 + diff_col}, {row1 - diff_row, col1 - diff_col}]
        end)
        |> List.flatten()
      else
        in_line =
          Enum.map(pairings, fn {{row0, col0}, {row1, col1}} ->
            diff_row = row0 - row1
            diff_col = col0 - col1

            gcd = Integer.gcd(diff_row, diff_col)
            diff_row = div(diff_row, gcd)
            diff_col = div(diff_col, gcd)

            list =
              for i <- 1..max(rows, cols),
                  do: [
                    {row0 + i * diff_row, col0 + i * diff_col},
                    {row1 - i * diff_row, col1 - i * diff_col}
                  ]

            List.flatten(list)
          end)
          |> List.flatten()

        in_line ++ locations
      end

    # Filter out-of-bound & antenna locations
    Enum.filter(antinode_candidates, fn {row, col} ->
      row >= 0 && col >= 0 && row < rows && col < cols
    end)
    |> Enum.filter(fn element ->
      part2 or not Enum.member?(locations, element)
    end)
  end
end

Day8.run()
