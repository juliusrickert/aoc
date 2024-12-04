defmodule Day4 do
  def run do
    input_matrix =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)

    # Add vertical buffer.
    matrix1 =
      input_matrix
      |> Enum.map(fn line -> "." <> line <> "." end)

    # Add horizontal buffer.
    line_length = String.length(hd(matrix1))
    buffer_line = String.duplicate(".", line_length)

    matrix1 =
      ([buffer_line] ++ matrix1 ++ [buffer_line])
      |> Enum.map(&Kernel.to_charlist/1)

    transformations1 = %{
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
      transformations1
      |> Enum.map(fn {_, func} -> func end)
      |> Enum.reduce(0, fn transformation, acc1 ->
        Enum.reduce(transformation, matrix1, fn func, acc2 ->
          acc2 |> func.()
        end)
        |> count_occurences()
        |> Kernel.+(acc1)
      end)

    IO.puts("part1: #{count_xmas}")

    #
    matrix2 =
      input_matrix
      |> Enum.map(fn line -> to_charlist(line) end)

    count_x_mas =
      matrix2
      |> submatrices(3)
      |> Enum.map(&is_x_mas/1)
      |> Enum.count(fn x -> x == true end)

    IO.puts("part2: #{count_x_mas}")
  end

  defp is_x_mas(matrix) do
    # Conjunctive normal form
    [
      [
        [&shift_rows/1, &transpose/1],
        [&shift_rows/1, &transpose/1, &mirror/1]
      ],
      [
        [&mirror/1, &shift_rows/1, &transpose/1],
        [&mirror/1, &shift_rows/1, &transpose/1, &mirror/1]
      ]
    ]
    |> Enum.all?(fn disjunctions ->
      disjunctions
      |> Enum.any?(fn disjunction_functions ->
        disjunction_functions
        |> Enum.reduce(matrix, fn func, acc ->
          acc |> func.()
        end)
        |> hd()
        |> to_string()
        |> Kernel.==("MAS")
      end)
    end)
  end

  # Get square submatrices from square matrix
  defp submatrices(matrix, n) do
    size = length(matrix)

    if n > size,
      do: throw("submatrix cannot be bigger than the matrix, matrix=#{size}, submatrix=#{n}")

    for row <- 0..(size - n), col <- 0..(size - n) do
      submatrix_at(matrix, row, col, n)
    end
  end

  defp submatrix_at(matrix, row, col, n) do
    for r <- row..(row + (n - 1)) do
      Enum.slice(Enum.at(matrix, r), col..(col + (n - 1)))
    end
  end

  defp count_occurences(matrix) do
    matrix
    |> Enum.map(fn line -> count_occurences_in_line(line, "XMAS") end)
    |> Enum.sum()
  end

  defp count_occurences_in_line(input, search) do
    input
    |> to_string()
    |> String.split(search)
    |> length()
    |> Kernel.-(1)
  end

  defp transpose(matrix) do
    matrix
    |> Enum.zip_with(&Function.identity/1)
  end

  defp mirror(matrix) do
    matrix
    |> Enum.map(&Enum.reverse/1)
  end

  defp shift_rows(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.map(&shift_row_n/1)
  end

  defp shift_row_n({row, n}) do
    {left, right} = Enum.split(row, n)
    right ++ left
  end
end

Day4.run()
