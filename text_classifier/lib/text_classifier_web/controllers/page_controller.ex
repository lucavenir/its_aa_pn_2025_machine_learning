defmodule TextClassifierWeb.PageController do
  use TextClassifierWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
