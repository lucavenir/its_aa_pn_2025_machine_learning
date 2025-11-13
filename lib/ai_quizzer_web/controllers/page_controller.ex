defmodule AiQuizzerWeb.PageController do
  use AiQuizzerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
