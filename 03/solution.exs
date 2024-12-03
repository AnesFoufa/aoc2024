defmodule Solution do
  def part_one(path) do
    ~r/mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(File.read!(path))
    |> Enum.map(fn [_, a, b] -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_two(path) do
    ~r/do\(\)|don't\(\)|mul\((\d{1,3}),(\d{1,3})\)/
    |> Regex.scan(File.read!(path))
    |> Enum.map(&read_instruction/1)
    |> Enum.reduce({:enable, 0}, &eval/2)
    |> then(fn {_status, sum} -> sum end)
    |> IO.puts()
  end

  defp read_instruction(["do()"]), do: :enable
  defp read_instruction(["don't()"]), do: :disable
  defp read_instruction([_, a, b]), do: {:mul, String.to_integer(a), String.to_integer(b)}

  defp eval(status, {_status, sum}) when status in [:enable, :disable], do: {status, sum}
  defp eval({:mul, a, b}, {:enable, sum}), do: {:enable, sum + a * b}
  defp eval(_instruction, {:disable, _sum} = state), do: state
end

path = System.argv() |> Enum.at(0)
Solution.part_one(path)
Solution.part_two(path)
