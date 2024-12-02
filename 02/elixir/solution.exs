defmodule Solution do
  def part_one(path) do
    solution(path, &safe_part_one?/1)
  end

  def part_two(path) do
    solution(path, &safe_part_two?/1)
  end

  defp solution(path, safe?) do
    path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn level ->
      level
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(safe?)
    |> length()
    |> IO.inspect()
  end

  defp safe_part_two?(level) do
    if safe_part_one?(level) do
      true
    else
      0..length(level)
      |> Enum.map(&without_index(level, &1))
      |> Enum.any?(&safe_part_one?/1)
    end
  end

  defp without_index(level, i) do
    level
    |> Enum.with_index()
    |> Enum.filter(fn {_, j} -> i != j end)
    |> Enum.map(fn {elem, _} -> elem end)
  end

  defp safe_part_one?(level) do
    growth_qualifications = get_growth_qualifications(level)

    Enum.all?(growth_qualifications, &(&1 == :increasing)) or
      Enum.all?(growth_qualifications, &(&1 == :decreasing))
  end

  defp get_growth_qualifications(level) do
    levels_first = Enum.slice(level, 0..-2//1)
    levels_lasts = Enum.slice(level, 1..-1//1)

    List.zip([levels_first, levels_lasts])
    |> Enum.map(fn {l1, l2} -> qualify_growth(l2 - l1) end)
  end

  def qualify_growth(growth) when growth >= 1 and growth <= 3, do: :increasing
  def qualify_growth(growth) when growth <= -1 and growth >= -3, do: :decreasing
  def qualify_growth(_), do: :unsafe
end

path = System.argv() |> Enum.at(0)
Solution.part_one(path)
Solution.part_two(path)
