defmodule Solution do
  def main(path) do
    %{part_1: part_1, part_2: part_2} =
      path
      |> File.stream!()
      |> Enum.reduce(%{facts: MapSet.new(), part_1: 0, part_2: 0}, &update_state/2)

    IO.puts(part_1)
    IO.puts(part_2)
  end

  defp update_state(line, state) do
    trimmed_line = String.trim(line, "\n")

    cond do
      String.contains?(trimmed_line, ["|"]) ->
        [page1, page2] =
          trimmed_line |> String.split("|", trim: true) |> Enum.map(&String.to_integer/1)

        %{state | facts: state[:facts] |> MapSet.put({page1, page2})}

      String.contains?(trimmed_line, ",") ->
        sequence = trimmed_line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
        update_state_with_sequence(state, sequence)

      true ->
        state
    end
  end

  defp update_state_with_sequence(
         %{facts: facts, part_1: part_1, part_2: part_2} = state,
         sequence
       ) do
    sorter = fn a, b -> a == b or {a, b} in facts end

    if sorted?(sequence, sorter) do
      %{state | part_1: part_1 + median(sequence)}
    else
      sorted_sequence = Enum.sort(sequence, sorter)
      %{state | part_2: part_2 + median(sorted_sequence)}
    end
  end

  defp sorted?(sequence, sorter) do
    seq1 = Enum.slice(sequence, 0..-2//1)
    seq2 = Enum.slice(sequence, 1..-1//1)
    List.zip([seq1, seq2]) |> Enum.all?(fn {p1, p2} -> sorter.(p1, p2) end)
  end

  defp median(enum) do
    i_median = Enum.count(enum) |> div(2)
    Enum.at(enum, i_median)
  end
end

path = System.argv() |> Enum.at(0)
Solution.main(path)
