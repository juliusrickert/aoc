defmodule Day5 do
  def run do
    input =
      IO.read(:stdio, :eof)

    [rules, instances] =
      input
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn block ->
        block
        |> String.split("\n", trim: true)
      end)

    rules =
      rules
      |> Enum.map(fn rule ->
        rule
        |> String.split("|", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)

    instances =
      instances
      |> Enum.map(fn rule ->
        rule
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)

    instances
    |> Enum.map(fn instance ->
      filtered_rules = filter_rules(instance, rules)
      (correct_order?(Enum.reverse(instance), filtered_rules) && middle_number(instance)) || 0
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part1")

    instances
    |> Enum.map(fn instance ->
      filtered_rules = filter_rules(instance, rules)
      reversed_instance = Enum.reverse(instance)

      (not correct_order?(reversed_instance, filtered_rules) &&
         middle_number(sort(reversed_instance, filtered_rules))) || 0
    end)
    |> Enum.sum()
    |> IO.inspect(label: "part2")
  end

  # Filters the rules for a given instance.
  # Both the antecedent and the consequent must be part of the instance.
  defp filter_rules(instance, rules) do
    rules
    |> Enum.filter(fn {antecedent, consequent} ->
      Enum.member?(instance, antecedent) and Enum.member?(instance, consequent)
    end)
  end

  # is_antecedent? is true if the page is on the "left side" of our rules.
  # As we have filtered the rules, they only include rules applicable to the given instance.
  # Consequently, the last page of any instance must not be the antecedent.
  defp is_antecedent?(page, rules) do
    length(consequents(page, rules)) > 0
  end

  defp consequents(page, rules) do
    rules
    |> Enum.filter(fn {antecedent, _} -> antecedent == page end)
    |> Enum.map(fn {_, consequent} -> consequent end)
  end

  # correct_order? checks whether a given reversed instance adheres to the rules.
  defp correct_order?([page | reversed_instance], rules) do
    not is_antecedent?(page, rules) and
      correct_order?(reversed_instance, filter_rules(reversed_instance, rules))
  end

  defp correct_order?([], _), do: true

  defp middle_number([num]), do: num
  defp middle_number([_ | rest]), do: middle_number(Enum.reverse(rest))

  defp sort([], _), do: []

  defp sort([page | reversed_instance], rules) do
    if not is_antecedent?(page, rules) do
      filtered_rules = filter_rules(reversed_instance, rules)
      [page | sort(reversed_instance, filtered_rules)]
    else
      conseqs = consequents(page, rules)

      new_reversed_instance =
        conseqs ++
          [page] ++ Enum.filter(reversed_instance, fn page -> not Enum.member?(conseqs, page) end)

      sort(new_reversed_instance, rules)
    end
  end
end

Day5.run()
