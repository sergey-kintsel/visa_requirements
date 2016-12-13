defmodule HtmlParser do
  def parse(html) do
    html
    |> Floki.find("#mw-content-text *")
    |> Enum.filter(fn {tag_name, _, _} -> tag_name in ~w[h2 table] end)
    |> parse_content(false)
  end

  defp parse_content([], _), do: :error 
  defp parse_content([x | xs], found_header) when not found_header do
    if requirements_header?(x) do
      parse_content(xs, true)
    else
      parse_content(xs, false)
    end
  end
  defp parse_content([{tag_name, _, _} | _], _) when tag_name != "table", do: :error
  defp parse_content([el | _], _), do: el |> Floki.find("table") |> parse_table

  defp requirements_header?({tag_name, _, _} = element) do
    tag_name == "h2" && tag_text(element) == "Visa requirements"
  end

  defp parse_table(table) do
    case Floki.find(table, "tr") do
      [_ | rows] -> Enum.map(rows, &parse_tr/1) # skip headers row
      _ -> :error  
    end 
  end

  defp parse_tr(tr) do
    tr
    |> Floki.find("td")
    |> Enum.map(&tag_text/1)
  end
  
  defp tag_text(tag) do
    tag
    |> Floki.text
    |> String.trim
    |> String.split("[") # We don't care about stuff after [. For example Visa requirements[edit].
    |> List.first
  end
end
