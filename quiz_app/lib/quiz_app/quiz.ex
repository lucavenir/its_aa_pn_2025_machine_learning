defmodule QuizApp.Quiz do
  @moduledoc """
  The Quiz domain API powered by Ash Framework.

  This module serves as the public interface for all quiz-related operations,
  including managing questions, quiz attempts, and answers.
  """

  use Ash.Domain

  resources do
    resource(QuizApp.Quiz.Question)
    resource(QuizApp.Quiz.QuizAttempt)
    resource(QuizApp.Quiz.Answer)
  end
end
