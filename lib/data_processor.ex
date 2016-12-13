defmodule DataProcessor do
  @good_signs ["Visa not required", "Visa on arrival", "Online Visitor",
               "eVisa", "e-Tourist Visa", "e-Visa", "Tourist Card on arrival"]
  def process(list) do
    [first | rest] = Enum.map(list, &process_data/1)
    Enum.reduce(first, [], fn country, acc ->
      present_in_all = Enum.all?(rest, fn countries -> 
        Enum.member?(Enum.map(countries, &String.downcase/1), String.downcase(country))
      end)
      if present_in_all do
        [country | acc]
      else
        acc
      end
    end)
  end

  defp process_data(data) do
    data
    |> Enum.filter_map(fn [_, requirement, _] ->
      not_required?(requirement)
    end, fn [country, _, _] -> country end)
  end

  defp not_required?(string) do
    # do something about "EU !Visa not required"
    @good_signs
    |> Enum.map(&String.downcase/1)
    |> Enum.any?(&(String.contains?(String.downcase(string), &1)))
  end
end
