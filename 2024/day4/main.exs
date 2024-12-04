defmodule Day4 do
  def run do
    input =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)
      |> Enum.map(fn line -> "." <> line <> "." end)

    # matrix = input
    # Horizontal buffer.
    line_length = String.length(hd(input))
    buffer_line = String.duplicate(".", line_length)
    matrix = [buffer_line] ++ input ++ [buffer_line]

    transformations = %{
      left_to_right: [],
      right_to_left: [&mirror/1],
      top_to_bottom: [&transpose/1],
      bottom_to_top: [&transpose/1, &mirror/1],
      topleft_to_bottomright: [&shift_rows/1, &transpose/1],
      topright_to_bottomleft: [&mirror/1, &shift_rows/1, &transpose/1],
      bottomleft_to_topright: [&transpose/1, &mirror/1, &shift_rows/1, &transpose/1],
      bottomright_to_topleft: [&mirror/1, &transpose/1, &mirror/1, &shift_rows/1, &transpose/1]
    }

    count_xmas =
      transformations
      |> Enum.map(fn {_, func} -> func end)
      |> Enum.reduce(0, fn transformation, acc1 ->
        Enum.reduce(transformation, matrix, fn func, acc2 ->
          acc2 |> func.()
        end)
        |> count_occurences()
        |> Kernel.+(acc1)
      end)

    IO.puts("part1: #{count_xmas}")
  end

  defp count_occurences(matrix) do
    matrix
    |> Enum.map(fn line -> count_occurences_in_line(line, "XMAS") end)
    |> Enum.sum()
  end

  defp count_occurences_in_line(input, search) do
    input
    |> String.split(search)
    |> length()
    |> Kernel.-(1)
  end

  defp transpose(matrix) do
    matrix
    |> Enum.map(&Kernel.to_charlist/1)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&Kernel.to_string/1)
  end

  defp mirror(matrix) do
    matrix
    |> Enum.map(&Kernel.to_charlist/1)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&Kernel.to_string/1)
  end

  defp shift_rows(matrix) do
    matrix
    |> Enum.map(&Kernel.to_charlist/1)
    |> Enum.with_index()
    |> Enum.map(&shift_row_n/1)
  end

  defp shift_row_n({row, n}) do
    {left, right} = Enum.split(row, n)
    to_string(right) <> to_string(left)
  end
end

Day4.run()
