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

    # Add orientation marker
    matrix1 = set_element({0, 0}, matrix1, ?0)

    part1 =
      orient_and_step(sp, matrix1)
      |> orient_matrix()
      |> find_all(?X)

    part1
    |> length()
    |> IO.inspect(label: "part1")

    part1
    |> Enum.map(&IO.inspect/1)

    # |> Enum.map(fn coords ->
    #   orient_and_step(sp, set_element(coords, matrix1, ?#))
    # end)
    # |> Enum.filter(fn item -> item == :loop end)
    # |> length()
    # |> IO.inspect(label: "part2")

    # 719 is too low
  end

  defp starting_point(matrix) do
    matrix |> find_all(?^) |> hd()
  end

  defp orient_and_step(sp, matrix) do
    # Orient matrix.
    {sp, matrix} = rotate_90deg_anticlockwise(sp, matrix)
    {sp, matrix} = rotate_90deg_anticlockwise(sp, matrix)
    {sp, matrix} = rotate_90deg_anticlockwise(sp, matrix)
    step(sp, matrix)
  end

  defp step({row, col}, matrix) do
    element = get_element({row, col}, matrix)
    next_element = get_element({row, col + 1}, matrix)

    if next_element == ?# do
      if element == ?X do
        # We are in a loop.
        IO.puts("loop found")
        :loop
      else
        {rotated_coordinates, rotated_matrix} = rotate_90deg_anticlockwise({row, col}, matrix)
        step(rotated_coordinates, rotated_matrix)
      end
    else
      matrix = set_element({row, col}, matrix, ?X)

      if next_element == ?* do
        IO.puts("solution found")
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

  # find_all returns the coordinates of all occurences of value in the matrix.
  defp find_all(matrix, value) do
    matrix
    |> Enum.with_index(fn line, row ->
      line
      |> Enum.with_index(fn element, col -> {row, col, element} end)
    end)
    |> List.flatten()
    |> Enum.filter(fn {_, _, element} -> element == value end)
    |> Enum.map(fn {row, col, _} -> {row, col} end)
  end

  defp orient_matrix(matrix) do
    if get_element({0, 0}, matrix) == ?0 do
      matrix
    else
      {_, matrix} = rotate_90deg_anticlockwise({0, 0}, matrix)
      matrix
    end
  end
end

Day6.run()
