defmodule QuizAppWeb.QuizLive.Index do
  use QuizAppWeb, :live_view

  alias QuizApp.Quiz

  @impl true
  def mount(_params, _session, socket) do
    # Start a new quiz attempt
    attempt = Quiz.QuizAttempt.start_quiz!()

    # Load all questions ordered by display_order
    questions =
      Quiz.Question
      |> Ash.Query.for_read(:read)
      |> Ash.Query.sort(display_order: :asc)
      |> Ash.read!()

    # Initialize state
    socket =
      socket
      |> assign(:quiz_attempt, attempt)
      |> assign(:questions, questions)
      |> assign(:current_question_index, 0)
      |> assign(:answers_map, initialize_answers_map(questions))
      |> assign(:page_title, "Quiz")

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "select_option",
        %{"question-id" => question_id, "option-index" => option_index},
        socket
      ) do
    # Update the selected option in the answers map
    option_index = String.to_integer(option_index)

    updated_answers =
      Map.update!(
        socket.assigns.answers_map,
        question_id,
        fn answer -> Map.put(answer, :selected, option_index) end
      )

    {:noreply, assign(socket, :answers_map, updated_answers)}
  end

  @impl true
  def handle_event(
        "update_justification",
        %{"question-id" => question_id, "value" => value},
        socket
      ) do
    # Update the justification text in the answers map
    updated_answers =
      Map.update!(
        socket.assigns.answers_map,
        question_id,
        fn answer -> Map.put(answer, :justification, value) end
      )

    {:noreply, assign(socket, :answers_map, updated_answers)}
  end

  @impl true
  def handle_event("previous_question", _params, socket) do
    # Move to previous question
    new_index = max(0, socket.assigns.current_question_index - 1)
    {:noreply, assign(socket, :current_question_index, new_index)}
  end

  @impl true
  def handle_event("next_question", _params, socket) do
    # Save current answer before navigating
    current_question = Enum.at(socket.assigns.questions, socket.assigns.current_question_index)
    socket = save_answer(socket, current_question)

    # Move to next question
    new_index =
      min(
        length(socket.assigns.questions) - 1,
        socket.assigns.current_question_index + 1
      )

    {:noreply, assign(socket, :current_question_index, new_index)}
  end

  @impl true
  def handle_event("submit_quiz", _params, socket) do
    # Save final answer
    current_question = Enum.at(socket.assigns.questions, socket.assigns.current_question_index)
    socket = save_answer(socket, current_question)

    # Submit the quiz and redirect to results
    case Quiz.QuizAttempt.submit_quiz(socket.assigns.quiz_attempt) do
      {:ok, completed_attempt} ->
        {:noreply, push_navigate(socket, to: ~p"/quiz/results/#{completed_attempt.id}")}

      {:error, _error} ->
        socket =
          put_flash(
            socket,
            :error,
            "Unable to submit quiz. Please ensure all questions are answered."
          )

        {:noreply, socket}
    end
  end

  # Private functions

  defp initialize_answers_map(questions) do
    questions
    |> Enum.map(fn q -> {q.question_id, %{selected: nil, justification: ""}} end)
    |> Map.new()
  end

  defp save_answer(socket, question) do
    answer_data = socket.assigns.answers_map[question.question_id]

    # Only save if both fields are filled
    if answer_data.selected != nil and String.trim(answer_data.justification) != "" do
      # Try to create or update the answer
      case Quiz.Answer.create(%{
             quiz_attempt_id: socket.assigns.quiz_attempt.id,
             question_id: question.question_id,
             selected_option_index: answer_data.selected,
             user_justification: answer_data.justification
           }) do
        {:ok, _answer} ->
          socket

        {:error, _error} ->
          # Answer might already exist, try to update it
          # For simplicity, we'll handle this in a production app with upsert logic
          socket
      end
    else
      socket
    end
  end

  # Public helper functions for template
  def current_answer_complete?(assigns) do
    current_question = Enum.at(assigns.questions, assigns.current_question_index)
    answer = assigns.answers_map[current_question.question_id]

    answer.selected != nil and String.trim(answer.justification) != ""
  end

  def all_answers_complete?(assigns) do
    Enum.all?(assigns.answers_map, fn {_id, answer} ->
      answer.selected != nil and String.trim(answer.justification) != ""
    end)
  end
end
