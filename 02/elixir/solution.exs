defmodule Solution do
  def part_one(path) do
    solution(path, &safe_part_one?/1)
  end

  def part_two(path) do
    solution(path, &safe_part_two?/1)
  end

  defp solution(path, safe?) do
    path
    |> File.stream!()
    |> Stream.map(&read_levels/1)
    |> Stream.filter(safe?)
    |> Enum.count()
    |> IO.puts()
  end

  defp read_levels(line) do
    line
    |> String.trim("\n")
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp safe_part_one?(level) do
    moderately_increasing?(level) or moderately_increasing?(Enum.reverse(level))
  end

  defp safe_part_two?(level) do
    if safe_part_one?(level) do
      true
    else
      0..(length(level) - 1)
      |> Stream.map(&without_index(level, &1))
      |> Enum.any?(&safe_part_one?/1)
    end
  end

  defp moderately_increasing?(level) do
    levels_firsts = Enum.slice(level, 0..-2//1)
    levels_lasts = Enum.slice(level, 1..-1//1)

    [levels_firsts, levels_lasts]
    |> List.zip()
    |> Enum.all?(fn {l1, l2} -> l2 > l1 and l2 <= l1 + 3 end)
  end

  defp without_index(level, i) do
    level
    |> Enum.with_index()
    |> Enum.filter(fn {_, j} -> i != j end)
    |> Enum.map(fn {elem, _} -> elem end)
  end
end

path = System.argv() |> Enum.at(0)
Solution.part_one(path)
Solution.part_two(path)
