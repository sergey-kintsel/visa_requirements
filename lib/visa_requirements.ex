defmodule VisaRequirements do
  def main(args) do
    args
    |> List.first
    |> String.split(",")
    |> Enum.map(fn code ->
      code
      |> String.trim
      |> String.downcase
      |> String.to_atom 
    end)
    |> Enum.map(fn code ->
      Application.get_env(:visa_requirements, :urls)[code]
    end)
    |> Enum.map(fn url ->
      Task.async(fn -> url |> load_data |> HtmlParser.parse end)
    end)
    |> Enum.map(&Task.await/1)
    |> DataProcessor.process
    |> Enum.sort
    |> Enum.each(&IO.puts/1)
  end

  def load_data(url) do
    %{body: body} = HTTPoison.get!(url)
    body
  end
end
