defmodule Solution do
  def part_one(path) do
    file_content = File.read!(path)

    file_content
    |> String.trim()
    |> String.split(~r/\n/)
    |> Enum.map(&String.split/1)
    |> List.foldl([[], []], fn [x, y], [l1, l2] ->
      [[String.to_integer(x) | l1], [String.to_integer(y) | l2]]
    end)
    |> Enum.map(&Enum.sort/1)
    |> List.zip()
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_two(path) do
    [left, right] =
      path
      |> File.read!()
      |> String.trim()
      |> String.split(~r/\n/)
      |> Enum.map(&String.split/1)
      |> List.foldl([[], []], fn [x, y], [l1, l2] ->
        [[String.to_integer(x) | l1], [String.to_integer(y) | l2]]
      end)

    right_freqs = Enum.frequencies(right)

    left
    |> Enum.map(fn x -> x * Map.get(right_freqs, x, 0) end)
    |> Enum.sum()
    |> IO.puts()
  end
end

System.argv() |> Enum.at(0) |> Solution.part_two()
