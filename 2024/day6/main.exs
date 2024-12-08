defmodule Day6 do
  def run do
    input_matrix =
      IO.read(:stdio, :eof)
      |> String.split("\n", trim: true)

    # Add vertical buffer.
    matrix1 =
      input_matrix
      |> Enum.map(fn line -> "*" <> line <> "*" end)

    # Add horizontal buffer.
    line_length = String.length(hd(matrix1))
    buffer_line = String.duplicate("*", line_length)

    matrix1 =
      ([buffer_line] ++ matrix1 ++ [buffer_line])
      |> Enum.map(&Kernel.to_charlist/1)

    # Find starting point.
    sp = starting_point(matrix1)
    matrix1 = set_element(sp, matrix1, ?X)

    # Orient matrix.
    {sp, rotated_matrix} = rotate_90deg_anticlockwise(sp, matrix1)
    {sp, rotated_matrix} = rotate_90deg_anticlockwise(sp, rotated_matrix)
    {sp, rotated_matrix} = rotate_90deg_anticlockwise(sp, rotated_matrix)

    step(sp, rotated_matrix)
    |> List.flatten()
    |> Enum.frequencies()
    |> Map.fetch!(?X)
    |> IO.inspect(label: "part1")
  end

  defp starting_point(matrix) do
    matrix
    |> Enum.with_index(fn line, row ->
      line
      |> Enum.with_index(fn element, col -> {row, col, element} end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {_, _, element} -> element == ?^ end)
    |> Enum.map(fn {row, col, _} -> {row, col} end)
    |> hd()
  end

  defp step({row, col}, matrix) do
    element = get_element({row, col + 1}, matrix)

    if element == ?# do
      {rotated_coordinates, rotated_matrix} = rotate_90deg_anticlockwise({row, col}, matrix)
      step(rotated_coordinates, rotated_matrix)
    else
      matrix = set_element({row, col}, matrix, ?X)

      if element == ?* do
        matrix
      else
        step({row, col + 1}, matrix)
      end
    end
  end

  defp get_element({row, col}, matrix) do
    matrix
    |> Enum.fetch!(row)
    |> Enum.fetch!(col)
  end

  defp set_element({r, c}, matrix, value) do
    Enum.with_index(matrix, fn row, index ->
      if r == index do
        List.replace_at(row, c, value)
      else
        row
      end
    end)
  end

  defp rotate_90deg_anticlockwise({row, col}, matrix) do
    rotated_matrix = matrix |> mirror() |> transpose()
    len = length(matrix)
    rotated_coordinates = {len - col - 1, row}
    {rotated_coordinates, rotated_matrix}
  end

  defp transpose(matrix) do
    matrix
    |> Enum.zip_with(&Function.identity/1)
  end

  defp mirror(matrix) do
    matrix
    |> Enum.map(&Enum.reverse/1)
  end
end

Day6.run()
