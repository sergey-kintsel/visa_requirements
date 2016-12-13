defmodule VisaRequirements do
  def main(args) do
    countries =
      args
      |> List.first
      |> String.split(",")
      |> Enum.map(fn code ->
        code
        |> String.trim
        |> String.downcase
        |> String.to_atom
      end)
      |> process
    Enum.each(countries, &IO.puts/1)
    IO.puts "Total: #{length(countries)}"
  end

  defp process(countries) do
    countries
    |> Enum.map(fn code ->
      {code, :visa_requirements |> Application.get_env(:urls) |> Map.get(code)}
    end)
    |> Enum.map(fn {code, url} ->
      Task.async(fn ->
        loaded =
          url |> load_data |> HtmlParser.parse
          |> Enum.map(fn [country, requirement, comments] ->
            struct(RequirementRecord, %{country: country,
                                        requirement: requirement,
                                        comments: comments})
          end)
        [RequirementRecord.own_country(code) | loaded]
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> DataProcessor.process
    |> Enum.sort
  end

  defp load_data(url) do
    %{body: body} = HTTPoison.get!(url)
    body
  end
end
