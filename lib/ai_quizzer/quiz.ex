defmodule AiQuizzer.Quiz do
  @moduledoc """
  The Quiz context.
  Provides functions to query and retrieve questions from the database.
  """

  import Ecto.Query, warn: false
  alias AiQuizzer.Repo
  alias AiQuizzer.Quiz.Question

  @doc """
  Returns the list of all questions.

  ## Examples

      iex> list_questions()
      [%Question{}, ...]

  """
  def list_questions do
    Repo.all(Question)
  end

  @doc """
  Gets a single question.

  Raises `Ecto.NoResultsError` if the Question does not exist.

  ## Examples

      iex> get_question!(123)
      %Question{}

      iex> get_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_question!(id), do: Repo.get!(Question, id)

  @doc """
  Returns a count of all questions in the database.

  ## Examples

      iex> count_questions()
      42

  """
  def count_questions do
    Repo.aggregate(Question, :count)
  end

  @doc """
  Returns a list of N random questions from the database.
  Defaults to 10 questions if count is not specified.

  ## Examples

      iex> random_questions()
      [%Question{}, ...] # 10 random questions

      iex> random_questions(5)
      [%Question{}, ...] # 5 random questions

  """
  def random_questions(count \\ 10) do
    from(q in Question, order_by: fragment("RANDOM()"), limit: ^count)
    |> Repo.all()
  end

  @doc """
  Creates a question.

  ## Examples

      iex> create_question(%{field: value})
      {:ok, %Question{}}

      iex> create_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_question(attrs \\ %{}) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end
end
