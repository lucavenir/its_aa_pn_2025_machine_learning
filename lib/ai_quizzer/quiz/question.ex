defmodule AiQuizzer.Quiz.Question do
  @moduledoc """
  Represents a quiz question with multiple choice options.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "questions" do
    field :question, :string
    field :option_1, :string
    field :option_2, :string
    field :option_3, :string
    field :option_4, :string
    field :correct_answer, :string
    field :motivation, :string

    timestamps(type: :naive_datetime)
  end

  @doc """
  Returns a list of all options for the question.
  """
  def options(%__MODULE__{} = question) do
    [question.option_1, question.option_2, question.option_3, question.option_4]
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [
      :question,
      :option_1,
      :option_2,
      :option_3,
      :option_4,
      :correct_answer,
      :motivation
    ])
    |> validate_required([
      :question,
      :option_1,
      :option_2,
      :option_3,
      :option_4,
      :correct_answer,
      :motivation
    ])
    |> validate_correct_answer_in_options()
  end

  defp validate_correct_answer_in_options(changeset) do
    correct_answer = get_field(changeset, :correct_answer)
    option_1 = get_field(changeset, :option_1)
    option_2 = get_field(changeset, :option_2)
    option_3 = get_field(changeset, :option_3)
    option_4 = get_field(changeset, :option_4)

    if correct_answer && correct_answer in [option_1, option_2, option_3, option_4] do
      changeset
    else
      add_error(changeset, :correct_answer, "must match one of the four options")
    end
  end
end
