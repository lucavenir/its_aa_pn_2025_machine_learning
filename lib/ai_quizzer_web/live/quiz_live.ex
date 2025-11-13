defmodule AiQuizzerWeb.QuizLive do
  @moduledoc """
  LiveView for the self-assessment quiz.
  Manages quiz sessions, user inputs, and results display.
  """
  use AiQuizzerWeb, :live_view

  alias AiQuizzer.Quiz

  @impl true
  def mount(_params, _session, socket) do
    # Fetch 10 random questions from database
    questions = Quiz.random_questions(10)

    socket =
      socket
      |> assign(:questions, questions)
      |> assign(:user_answers, %{})
      |> assign(:view_mode, :quiz)
      |> assign(:submission_enabled, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("select_option", %{"index" => index_str, "option" => option}, socket) do
    index = String.to_integer(index_str)

    user_answers =
      socket.assigns.user_answers
      |> Map.put_new(index, %{})
      |> Map.update!(index, fn answer -> Map.put(answer, :option, option) end)

    socket =
      socket
      |> assign(:user_answers, user_answers)
      |> update_submission_status()

    {:noreply, socket}
  end

  @impl true
  def handle_event("update_justification", %{"index" => index_str, "value" => text}, socket) do
    index = String.to_integer(index_str)

    user_answers =
      socket.assigns.user_answers
      |> Map.put_new(index, %{})
      |> Map.update!(index, fn answer -> Map.put(answer, :justification, text) end)

    socket =
      socket
      |> assign(:user_answers, user_answers)
      |> update_submission_status()

    {:noreply, socket}
  end

  @impl true
  def handle_event("submit_quiz", _params, socket) do
    socket = assign(socket, :view_mode, :results)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_quiz", _params, socket) do
    # Fetch new random questions
    questions = Quiz.random_questions(10)

    socket =
      socket
      |> assign(:questions, questions)
      |> assign(:user_answers, %{})
      |> assign(:view_mode, :quiz)
      |> assign(:submission_enabled, false)

    {:noreply, socket}
  end

  # Private helpers

  defp update_submission_status(socket) do
    enabled =
      all_questions_answered?(socket.assigns.user_answers, length(socket.assigns.questions))

    assign(socket, :submission_enabled, enabled)
  end

  defp all_questions_answered?(user_answers, total_questions) do
    # Check if all questions (0 to total_questions - 1) have both option and justification
    Enum.all?(0..(total_questions - 1), fn index ->
      case Map.get(user_answers, index) do
        nil ->
          false

        answer ->
          has_option = Map.has_key?(answer, :option) && answer.option != nil

          has_justification =
            Map.has_key?(answer, :justification) &&
              String.trim(answer.justification || "") != ""

          has_option && has_justification
      end
    end)
  end
end
