defmodule LawadvisorWeb.TaskView do
  use LawadvisorWeb, :view

  def render("result.json", %{result: result}), do: result

end
