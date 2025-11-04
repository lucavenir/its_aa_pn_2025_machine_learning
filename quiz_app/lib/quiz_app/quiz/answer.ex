defmodule QuizApp.Quiz.Answer do
  @moduledoc """
  Represents a user's answer to a specific quiz question.

  Contains:
  - The selected multiple-choice option (0-3)
  - The user's justification text
  - Belongs to a quiz attempt and a question
  """

  use Ash.Resource,
    domain: QuizApp.Quiz,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("answers")
    repo(QuizApp.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :selected_option_index, :integer do
      allow_nil?(false)
      constraints(min: 0, max: 3)
    end

    attribute :user_justification, :string do
      allow_nil?(false)
      constraints(min_length: 1)
    end

    create_timestamp(:created_at)
    update_timestamp(:updated_at)
  end

  calculations do
    calculate(:is_correct, :boolean, expr(selected_option_index == question.correct_option_index))
  end

  relationships do
    belongs_to :quiz_attempt, QuizApp.Quiz.QuizAttempt do
      allow_nil?(false)
      attribute_writable?(true)
    end

    belongs_to :question, QuizApp.Quiz.Question do
      allow_nil?(false)
      attribute_writable?(true)
      source_attribute(:question_id)
      destination_attribute(:question_id)
      attribute_type(:string)
    end
  end

  actions do
    defaults([:read])

    create :create do
      accept([:selected_option_index, :user_justification, :quiz_attempt_id, :question_id])
    end

    update :update do
      accept([:selected_option_index, :user_justification])
    end
  end

  identities do
    # Each quiz attempt can only have one answer per question
    identity(:unique_answer_per_question, [:quiz_attempt_id, :question_id])
  end

  code_interface do
    define(:create)
    define(:update)
    define(:read)
    define(:by_id, action: :read, get_by: [:id])
  end
end
