defmodule LawadvisorWeb.RegisterView do
  use LawadvisorWeb, :view

  def render("result.json", %{result: result}), do: result

end
