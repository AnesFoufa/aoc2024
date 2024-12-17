defmodule Solution do
  def main(path) do
    solve(path, false)
    solve(path, true)
  end

  defp solve(path, part2) do
    File.stream!(path)
    |> Stream.map(&read_equation/1)
    |> Stream.filter(fn eq -> solvable?(eq, part2) end)
    |> Stream.map(fn {test_value, _} -> test_value end)
    |> Enum.sum()
    |> IO.puts()
  end

  defp read_equation(line) do
    [test_value_str, numbers_line] =
      line
      |> String.trim()
      |> String.split(":")

    test_value = String.to_integer(test_value_str, 10)

    numbers =
      numbers_line
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {test_value, numbers}
  end

  defp solvable?({test_value, [first_number | numbers]}, part2),
    do: solvable?({test_value, numbers}, first_number, part2)

  defp solvable?({test_value, []}, test_value, _part2), do: true
  defp solvable?({_test_value, []}, _acc, _part2), do: false

  defp solvable?({test_value, [first_number | numbers]}, acc, part2) do
    solvable?({test_value, numbers}, acc + first_number, part2) or
      solvable?({test_value, numbers}, acc * first_number, part2) or
      (part2 and solvable?({test_value, numbers}, concat(acc, first_number), part2))
  end

  defp concat(n1, n2) do
    String.to_integer("#{n1}#{n2}")
  end
end

System.argv() |> Enum.at(0) |> Solution.main()
