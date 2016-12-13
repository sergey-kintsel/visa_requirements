defmodule RequirementRecord do
  defstruct country: "", requirement: "", comments: ""

  def own_country(code) do
    country =
      :visa_requirements
      |> Application.get_env(:names)
      |> Map.get(code)
    struct(__MODULE__, %{country: country, requirement: "Visa not required"})
  end
end
