defmodule LawadvisorWeb.PageController do
  use LawadvisorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
