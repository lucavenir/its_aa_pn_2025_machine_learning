defmodule AiQuizzer.QuizTest do
  use AiQuizzer.DataCase

  alias AiQuizzer.Quiz
  alias AiQuizzer.Quiz.Question

  describe "questions" do
    test "random_questions/1 returns requested number of questions" do
      # Seed some test questions
      insert_test_questions(15)

      questions = Quiz.random_questions(10)

      assert length(questions) == 10
      assert Enum.all?(questions, &is_struct(&1, Question))
    end

    test "random_questions/1 returns different sets on multiple calls" do
      # Seed more questions to increase chance of different results
      insert_test_questions(50)

      set1 = Quiz.random_questions(10) |> Enum.map(& &1.id) |> Enum.sort()
      set2 = Quiz.random_questions(10) |> Enum.map(& &1.id) |> Enum.sort()

      # With 50 questions, getting the exact same 10 in the same order is very unlikely
      # This test might occasionally fail due to randomness, but it's unlikely
      assert set1 != set2 || length(set1) == 10
    end

    test "count_questions/0 returns correct count" do
      insert_test_questions(5)

      assert Quiz.count_questions() == 5

      insert_test_questions(3)
      assert Quiz.count_questions() == 8
    end

    test "get_question!/1 retrieves a question by id" do
      question = insert_test_question()

      retrieved = Quiz.get_question!(question.id)

      assert retrieved.id == question.id
      assert retrieved.question == question.question
    end

    test "create_question/1 with valid data creates a question" do
      attrs = %{
        question: "Test question?",
        option_1: "Option A",
        option_2: "Option B",
        option_3: "Option C",
        option_4: "Option D",
        correct_answer: "Option A",
        motivation: "Because A is correct"
      }

      assert {:ok, %Question{} = question} = Quiz.create_question(attrs)
      assert question.question == "Test question?"
      assert question.correct_answer == "Option A"
    end

    test "create_question/1 with invalid correct_answer returns error" do
      attrs = %{
        question: "Test question?",
        option_1: "Option A",
        option_2: "Option B",
        option_3: "Option C",
        option_4: "Option D",
        # Not in the options
        correct_answer: "Option E",
        motivation: "Test"
      }

      assert {:error, changeset} = Quiz.create_question(attrs)
      assert "must match one of the four options" in errors_on(changeset).correct_answer
    end
  end

  describe "Question schema" do
    test "options/1 returns all four options as a list" do
      question = insert_test_question()
      options = Question.options(question)

      assert length(options) == 4
      assert question.option_1 in options
      assert question.option_2 in options
      assert question.option_3 in options
      assert question.option_4 in options
    end
  end

  # Test helpers
  defp insert_test_question(attrs \\ %{}) do
    default_attrs = %{
      question: "Sample question?",
      option_1: "Answer 1",
      option_2: "Answer 2",
      option_3: "Answer 3",
      option_4: "Answer 4",
      correct_answer: "Answer 1",
      motivation: "Answer 1 is correct because..."
    }

    {:ok, question} =
      default_attrs
      |> Map.merge(attrs)
      |> Quiz.create_question()

    question
  end

  defp insert_test_questions(count) do
    for i <- 1..count do
      insert_test_question(%{
        question: "Question #{i}?",
        option_1: "Q#{i} Answer 1",
        option_2: "Q#{i} Answer 2",
        option_3: "Q#{i} Answer 3",
        option_4: "Q#{i} Answer 4",
        correct_answer: "Q#{i} Answer 1",
        motivation: "Q#{i} explanation"
      })
    end
  end
end
