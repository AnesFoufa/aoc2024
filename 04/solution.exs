defmodule Solution do
  @xmas ~r/XMAS/
  @samx ~r/SAMX/

  def part_one(matrix) do
    transposed = transpose(matrix)
    diagonals = all_diagonals(matrix)

    (matrix ++ transposed ++ diagonals)
    |> Enum.map(&nb_matches/1)
    |> Enum.sum()
  end

  def part_two(matrix) do
    dimension = length(matrix)

    for i <- 0..(dimension - 3),
        j <- 0..(dimension - 3),
        window = Enum.slice(matrix, i, 3) |> Enum.map(&Enum.slice(&1, j, 3)),
        x_mas?(window) do
      1
    end
    |> length()
  end

  def read_matrix(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
  end

  defp transpose(matrix) do
    matrix
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp all_diagonals(matrix) do
    # Get the dimensions of the matrix
    rows = length(matrix)
    cols = length(Enum.at(matrix, 0))

    # Generate diagonals from top-left to bottom-right
    top_left_diagonals =
      for offset <- -(rows - 1)..(cols - 1) do
        for r <- 0..(rows - 1),
            c = r - offset,
            c >= 0 and c <= cols - 1 do
          Enum.at(Enum.at(matrix, r), c)
        end
      end

    # Generate diagonals from top-right to bottom-left
    top_right_diagonals =
      for offset <- 0..(rows + cols - 1) do
        for r <- 0..(rows - 1),
            c = offset - r,
            c >= 0 and c <= cols - 1 do
          Enum.at(Enum.at(matrix, r), c)
        end
      end

    # Combine and remove empty lists
    top_left_diagonals ++ top_right_diagonals
  end

  defp nb_matches(row) do
    row_string = to_string(row)
    matches_for_xmas = Regex.scan(@xmas, row_string) |> length()
    matches_for_samx = Regex.scan(@samx, row_string) |> length()
    matches_for_xmas + matches_for_samx
  end

  defp x_mas?(matrix) do
    diagonal_top_left = 0..2 |> Enum.map(&Enum.at(Enum.at(matrix, &1), &1))
    diagonal_top_right = 0..2 |> Enum.map(&Enum.at(Enum.at(matrix, &1), 2 - &1))
    diagonal_top_left in [~c"MAS", ~c"SAM"] and diagonal_top_right in [~c"MAS", ~c"SAM"]
  end
end

[path] = System.argv()
matrix = Solution.read_matrix(path)
Solution.part_one(matrix) |> IO.puts()
Solution.part_two(matrix) |> IO.puts()
