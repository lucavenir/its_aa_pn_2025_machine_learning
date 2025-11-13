defmodule AiQuizzerWeb.PageControllerTest do
  use AiQuizzerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    # Since we route "/" to QuizLive, we should get a LiveView mount response
    assert html_response(conn, 200) =~ "Self-Assessment Quiz"
  end
end
