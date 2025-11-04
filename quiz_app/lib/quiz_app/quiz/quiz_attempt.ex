defmodule QuizApp.Quiz.QuizAttempt do
  @moduledoc """
  Represents a single attempt at taking the quiz.

  Tracks:
  - When the attempt started
  - When it was submitted
  - The final score (0-10)
  - All associated answers
  """

  use Ash.Resource,
    domain: QuizApp.Quiz,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("quiz_attempts")
    repo(QuizApp.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :started_at, :utc_datetime_usec do
      allow_nil?(false)
      default(&DateTime.utc_now/0)
    end

    attribute :submitted_at, :utc_datetime_usec do
      allow_nil?(true)
    end

    attribute :score, :integer do
      allow_nil?(true)
      constraints(min: 0, max: 10)
    end

    create_timestamp(:created_at)
    update_timestamp(:updated_at)
  end

  calculations do
    calculate(
      :score_percentage,
      :float,
      expr(
        if is_nil(score) do
          nil
        else
          score * 10.0
        end
      )
    )
  end

  relationships do
    has_many :answers, QuizApp.Quiz.Answer do
      destination_attribute(:quiz_attempt_id)
    end
  end

  actions do
    defaults([:read])

    create :start_quiz do
      accept([])
    end

    update :submit_quiz do
      require_atomic?(false)
      accept([])

      change(fn changeset, _context ->
        # Load the attempt with all answers and their questions
        attempt = Ash.Changeset.get_data(changeset)

        loaded_attempt =
          QuizApp.Quiz.QuizAttempt
          |> Ash.get!(attempt.id, load: [answers: :question])

        # Calculate score by comparing selected vs correct indices
        score =
          Enum.count(loaded_attempt.answers, fn answer ->
            answer.selected_option_index == answer.question.correct_option_index
          end)

        # Set submitted_at and score
        changeset
        |> Ash.Changeset.change_attribute(:submitted_at, DateTime.utc_now())
        |> Ash.Changeset.change_attribute(:score, score)
      end)

      validate(fn changeset, _context ->
        # Ensure we have 10 answers before submitting
        attempt = Ash.Changeset.get_data(changeset)

        loaded_attempt =
          QuizApp.Quiz.QuizAttempt
          |> Ash.get!(attempt.id, load: :answers)

        answer_count = length(loaded_attempt.answers)

        if answer_count != 10 do
          {:error, field: :answers, message: "Must answer all 10 questions before submitting"}
        else
          :ok
        end
      end)
    end
  end

  code_interface do
    define(:start_quiz)
    define(:submit_quiz)
    define(:read)
    define(:by_id, action: :read, get_by: [:id])
  end
end
