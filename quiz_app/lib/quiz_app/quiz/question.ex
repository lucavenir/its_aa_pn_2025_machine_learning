defmodule QuizApp.Quiz.Question do
  @moduledoc """
  Represents a quiz question with multiple-choice options and expert rationale.

  Each question contains:
  - A unique question_id (e.g., "q1", "q2")
  - The question text
  - Four answer options
  - The index of the correct answer (0-3)
  - An expert rationale explaining why the answer is correct
  - Display order for consistent presentation
  """

  use Ash.Resource,
    domain: QuizApp.Quiz,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("questions")
    repo(QuizApp.Repo)
  end

  attributes do
    # Using string ID for semantic identifiers like "q1", "q2"
    attribute :question_id, :string do
      allow_nil?(false)
      primary_key?(true)
    end

    attribute :question_text, :string do
      allow_nil?(false)
    end

    # Array of exactly 4 string options
    attribute :options, {:array, :string} do
      allow_nil?(false)
      constraints(min_length: 4, max_length: 4)
    end

    # Index (0-3) pointing to the correct option
    attribute :correct_option_index, :integer do
      allow_nil?(false)
      constraints(min: 0, max: 3)
    end

    attribute :expert_rationale, :string do
      allow_nil?(false)
    end

    # For ordering questions 1-10
    attribute :display_order, :integer do
      allow_nil?(false)
      constraints(min: 1, max: 10)
    end

    create_timestamp(:created_at)
    update_timestamp(:updated_at)
  end

  relationships do
    has_many :answers, QuizApp.Quiz.Answer do
      destination_attribute(:question_id)
      source_attribute(:question_id)
    end
  end

  actions do
    defaults([:read])

    create :create do
      accept([
        :question_id,
        :question_text,
        :options,
        :correct_option_index,
        :expert_rationale,
        :display_order
      ])
    end
  end

  identities do
    identity(:unique_question_id, [:question_id])
    identity(:unique_display_order, [:display_order])
  end

  code_interface do
    define(:create)
    define(:read)
    define(:by_id, action: :read, get_by: [:question_id])
    define(:list_ordered, action: :read, args: [])
  end
end
