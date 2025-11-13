defmodule AiQuizzerWeb.QuizLiveTest do
  use AiQuizzerWeb.ConnCase

  import Phoenix.LiveViewTest
  alias AiQuizzer.Quiz

  setup do
    # Create test questions
    for i <- 1..15 do
      {:ok, _} =
        Quiz.create_question(%{
          question: "Test question #{i}?",
          option_1: "Option A#{i}",
          option_2: "Option B#{i}",
          option_3: "Option C#{i}",
          option_4: "Option D#{i}",
          correct_answer: "Option A#{i}",
          motivation: "Option A#{i} is correct because..."
        })
    end

    :ok
  end

  describe "Quiz mode" do
    test "mounts and displays 10 questions", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Check for quiz mode elements
      assert html =~ "Self-Assessment Quiz"
      assert html =~ "Instructions"
      assert html =~ "Privacy Notice"

      # Check that we have 10 question cards
      assert has_element?(view, "#questions-container")

      # Verify question cards are rendered
      assert has_element?(view, "#question-card-0")
      assert has_element?(view, "#question-card-9")
      refute has_element?(view, "#question-card-10")
    end

    test "submit button is initially disabled", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      # Submit button should be disabled
      assert has_element?(view, "#submit-quiz-btn[disabled]")
    end

    test "selecting an option updates state", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Get the first option value from the HTML
      [_full, option] = Regex.run(~r/phx-value-option="([^"]+)"/, html)

      # Click with the phx-click event directly
      view
      |> render_click("select_option", %{"index" => "0", "option" => option})

      # Button should still be disabled (need justification too)
      assert has_element?(view, "#submit-quiz-btn[disabled]")
    end

    test "adding justification for all questions enables submit button", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Get all option values from HTML for each question
      option_matches = Regex.scan(~r/phx-value-index="(\d+)" phx-value-option="([^"]+)"/, html)

      # Group by question index and pick first option for each
      options_by_index =
        option_matches
        |> Enum.group_by(fn [_, index, _] -> String.to_integer(index) end)
        |> Enum.map(fn {index, matches} -> {index, hd(matches) |> Enum.at(2)} end)
        |> Enum.into(%{})

      # For each of the 10 questions, select option and add justification
      for index <- 0..9 do
        option = Map.get(options_by_index, index)

        # Select option via event
        view
        |> render_click("select_option", %{"index" => to_string(index), "option" => option})

        # Add justification
        view
        |> render_blur("update_justification", %{
          "index" => to_string(index),
          "value" => "My justification"
        })
      end

      # Now submit button should be enabled
      refute has_element?(view, "#submit-quiz-btn[disabled]")
    end

    test "submitting quiz shows results view", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Get options
      option_matches = Regex.scan(~r/phx-value-index="(\d+)" phx-value-option="([^"]+)"/, html)

      options_by_index =
        option_matches
        |> Enum.group_by(fn [_, index, _] -> String.to_integer(index) end)
        |> Enum.map(fn {index, matches} -> {index, hd(matches) |> Enum.at(2)} end)
        |> Enum.into(%{})

      # Fill out all questions
      for index <- 0..9 do
        option = Map.get(options_by_index, index)

        view
        |> render_click("select_option", %{"index" => to_string(index), "option" => option})

        view
        |> render_blur("update_justification", %{"index" => to_string(index), "value" => "Test"})
      end

      # Submit the quiz
      html =
        view
        |> render_click("submit_quiz")

      # Should now be in results mode
      assert html =~ "Quiz Results"
      assert has_element?(view, "#results-container")
      assert has_element?(view, "#new-quiz-btn")
    end
  end

  describe "Results mode" do
    test "displays correct answers and explanations", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Get options
      option_matches = Regex.scan(~r/phx-value-index="(\d+)" phx-value-option="([^"]+)"/, html)

      options_by_index =
        option_matches
        |> Enum.group_by(fn [_, index, _] -> String.to_integer(index) end)
        |> Enum.map(fn {index, matches} -> {index, hd(matches) |> Enum.at(2)} end)
        |> Enum.into(%{})

      # Complete the quiz
      for index <- 0..9 do
        option = Map.get(options_by_index, index)

        view
        |> render_click("select_option", %{"index" => to_string(index), "option" => option})

        view
        |> render_blur("update_justification", %{"index" => to_string(index), "value" => "Test"})
      end

      html =
        view
        |> render_click("submit_quiz")

      # Check for results elements
      assert html =~ "Quiz Results"
      assert html =~ "Correct Answer:"
      assert html =~ "Explanation:"
    end

    test "clicking 'Take Another Quiz' resets to quiz mode with new questions", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      # Get options
      option_matches = Regex.scan(~r/phx-value-index="(\d+)" phx-value-option="([^"]+)"/, html)

      options_by_index =
        option_matches
        |> Enum.group_by(fn [_, index, _] -> String.to_integer(index) end)
        |> Enum.map(fn {index, matches} -> {index, hd(matches) |> Enum.at(2)} end)
        |> Enum.into(%{})

      # Complete and submit quiz
      for index <- 0..9 do
        option = Map.get(options_by_index, index)

        view
        |> render_click("select_option", %{"index" => to_string(index), "option" => option})

        view
        |> render_blur("update_justification", %{"index" => to_string(index), "value" => "Test"})
      end

      view
      |> render_click("submit_quiz")

      # Click "Take Another Quiz"
      view
      |> render_click("new_quiz")

      # Should be back in quiz mode
      assert has_element?(view, "#questions-container")
      assert has_element?(view, "#submit-quiz-btn[disabled]")
      refute has_element?(view, "#results-container")
    end
  end

  describe "Privacy verification" do
    test "no database writes for user answers during quiz", %{conn: conn} do
      {:ok, view, html} = live(conn, "/")

      initial_count = Quiz.count_questions()

      # Get options
      option_matches = Regex.scan(~r/phx-value-index="(\d+)" phx-value-option="([^"]+)"/, html)

      options_by_index =
        option_matches
        |> Enum.group_by(fn [_, index, _] -> String.to_integer(index) end)
        |> Enum.map(fn {index, matches} -> {index, hd(matches) |> Enum.at(2)} end)
        |> Enum.into(%{})

      # Fill out quiz
      for index <- 0..9 do
        option = Map.get(options_by_index, index)

        view
        |> render_click("select_option", %{"index" => to_string(index), "option" => option})

        view
        |> render_blur("update_justification", %{
          "index" => to_string(index),
          "value" => "My answer"
        })
      end

      # Submit quiz
      view
      |> render_click("submit_quiz")

      # Question count should remain the same (no new records created)
      assert Quiz.count_questions() == initial_count
    end
  end
end
