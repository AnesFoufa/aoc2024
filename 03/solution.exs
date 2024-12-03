defmodule Solution do
  def part_one(path) do
    path
    |> File.read!()
    |> extract_and_evaluate()
  end

  def part_two(path) do
    path
    |> File.read!()
    |> then(&Regex.replace(~r/don't\(\).*?do\(\)/s, &1, " "))
    |> extract_and_evaluate()
  end

  defp extract_and_evaluate(file_content) do
    file_content
    |> then(&Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, &1))
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
    |> IO.puts()
  end
end

path = System.argv() |> Enum.at(0)
Solution.part_one(path)
Solution.part_two(path)
