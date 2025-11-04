defmodule QuizAppWeb.QuizLive.Results do
  use QuizAppWeb, :live_view

  alias QuizApp.Quiz

  @impl true
  def mount(%{"id" => attempt_id}, _session, socket) do
    # Load the quiz attempt with all answers and their questions
    attempt = Quiz.QuizAttempt
      |> Ash.get!(attempt_id, load: [answers: :question])

    # Sort answers by question display_order for consistent presentation
    sorted_answers = Enum.sort_by(attempt.answers, & &1.question.display_order)

    socket = 
      socket
      |> assign(:quiz_attempt, attempt)
      |> assign(:answers, sorted_answers)
      |> assign(:page_title, "Quiz Results")

    {:ok, socket}
  end

  # Public helper functions for template
  def get_selected_option(answer) do
    Enum.at(answer.question.options, answer.selected_option_index)
  end

  def get_correct_option(question) do
    Enum.at(question.options, question.correct_option_index)
  end

  def is_answer_correct?(answer) do
    answer.selected_option_index == answer.question.correct_option_index
  end
end
