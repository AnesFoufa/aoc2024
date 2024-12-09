defmodule Solution do
  def main(path) do
    map =
      File.read!(path)
      |> String.split("\n", trim: true)
      |> Enum.map(&to_charlist/1)

    %{map: map, position: initial_position} =
      map
      |> Enum.with_index()
      |> Enum.reduce(%{map: [], position: nil}, &read_state_from_line/2)
      |> then(&%{&1 | map: Enum.reverse(&1[:map])})

    {visited_positions, false} = move(%{map: map, position: initial_position})

    format_map(map, visited_positions)
    |> Enum.map(&to_string/1)
    |> Enum.each(&IO.puts(&1))

    visited_positions |> Enum.count() |> IO.puts()

    for {i, j} <- visited_positions,
        {i, j} != initial_position,
        map_with_obstacle = update_map(map, i, j, ?#),
        {_visited_positions, cycle} = move(%{map: map_with_obstacle, position: initial_position}),
        cycle do
      {i, j}
    end
    |> Enum.count()
    |> IO.puts()
  end

  defp read_state_from_line({line, i}, state) do
    case Enum.find_index(line, &(&1 == ?^)) do
      nil ->
        %{state | map: [line | state[:map]]}

      j ->
        %{
          state
          | map: [Enum.map(line, &if(&1 == ?^, do: ?., else: &1)) | state[:map]],
            position: {i, j, :up}
        }
    end
  end

  defp move(%{position: {i, j, _}} = state) do
    move(state, {MapSet.new([{i, j}]), MapSet.new([state])})
  end

  defp move(
         %{position: {i, j, direction}, map: map} = state,
         {visited_positions, starting_positions}
       ) do
    {new_visited_positions, new_position} = move_guard({i, j, direction}, map)
    cycle = new_position in starting_positions
    up_to_date_starting_positions = MapSet.put(starting_positions, new_position)
    up_to_date_visited_position = MapSet.union(visited_positions, new_visited_positions)

    if is_nil(new_position) or cycle do
      {up_to_date_visited_position, cycle}
    else
      move(
        %{state | position: new_position},
        {up_to_date_visited_position, up_to_date_starting_positions}
      )
    end
  end

  defp move_guard({i, j, :up}, map), do: move_up({i, j}, map)
  defp move_guard({i, j, :down}, map), do: move_down({i, j}, map)
  defp move_guard({i, j, :left}, map), do: move_left({i, j}, map)
  defp move_guard({i, j, :right}, map), do: move_right({i, j}, map)

  defp move_up({i, j}, map) do
    case Enum.slice(map, 0..i)
         |> Enum.map(&Enum.at(&1, j))
         |> Enum.with_index()
         |> Enum.filter(fn {x, _} -> x == ?# end)
         |> Enum.map(fn {_x, i_} -> i_ end)
         |> Enum.max(&>=/2, fn -> nil end) do
      nil ->
        new_visited_positions = 0..i |> Enum.map(&{&1, j}) |> MapSet.new()
        {new_visited_positions, nil}

      i_ ->
        new_visited_positions = (i_ + 1)..i |> Enum.map(&{&1, j}) |> MapSet.new()
        new_position = {i_ + 1, j, :right}
        {new_visited_positions, new_position}
    end
  end

  defp move_down({i, j}, map) do
    nb_rows = Enum.count(map)

    case Enum.slice(map, i..-1//1)
         |> Enum.map(&Enum.at(&1, j))
         |> Enum.find_index(&(&1 == ?#)) do
      nil ->
        new_visited_positions = i..(nb_rows - 1) |> Enum.map(&{&1, j}) |> MapSet.new()
        {new_visited_positions, nil}

      i_ ->
        new_visited_positions = i..(i_ + i - 1) |> Enum.map(&{&1, j}) |> MapSet.new()
        new_position = {i_ + i - 1, j, :left}
        {new_visited_positions, new_position}
    end
  end

  def move_left({i, j}, map) do
    case map
         |> Enum.at(i)
         |> Enum.slice(0..j)
         |> Enum.with_index()
         |> Enum.filter(fn {x, _} -> x == ?# end)
         |> Enum.map(fn {_x, j_} -> j_ end)
         |> Enum.max(&>=/2, fn -> nil end) do
      nil ->
        new_visited_positions = 0..j |> Enum.map(&{i, &1}) |> MapSet.new()
        {new_visited_positions, nil}

      j_ ->
        new_visited_positions = (j_ + 1)..j |> Enum.map(&{i, &1}) |> MapSet.new()
        new_position = {i, j_ + 1, :up}
        {new_visited_positions, new_position}
    end
  end

  def move_right({i, j}, map) do
    case map |> Enum.at(i) |> Enum.slice(j..-1//1) |> Enum.find_index(&(&1 == ?#)) do
      nil ->
        nb_columns = map |> Enum.at(0) |> Enum.count()
        new_visited_positions = j..(nb_columns - 1) |> Enum.map(&{i, &1}) |> MapSet.new()
        {new_visited_positions, nil}

      j_ ->
        new_visited_positions = j..(j + j_ - 1) |> Enum.map(&{i, &1}) |> MapSet.new()
        new_position = {i, j + j_ - 1, :down}
        {new_visited_positions, new_position}
    end
  end

  defp format_map(map, visited_positions) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, i} ->
      Enum.with_index(row)
      |> Enum.map(fn {elem, j} -> if {i, j} in visited_positions, do: ?X, else: elem end)
    end)
  end

  defp update_map(map, i, j, replacement) do
    map
    |> Enum.with_index()
    |> Enum.map(fn {row, i_} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {c, j_} -> if {i, j} == {i_, j_}, do: replacement, else: c end)
    end)
  end
end

path = System.argv() |> Enum.at(0)
Solution.main(path)
