# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AiQuizzer.Repo.insert!(%AiQuizzer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AiQuizzer.Repo
alias AiQuizzer.Quiz.Question

# Clear existing questions
Repo.delete_all(Question)

# Read and parse the seeding.json file
json_path = Path.join(:code.priv_dir(:ai_quizzer), "../seeding.json")

case File.read(json_path) do
  {:ok, content} ->
    case Jason.decode(content) do
      {:ok, questions_data} ->
        IO.puts("Loading #{length(questions_data)} questions from seeding.json...")

        questions_data
        |> Enum.with_index(1)
        |> Enum.each(fn {question_data, index} ->
          # Validate that we have exactly 4 options
          options = question_data["options"]

          if length(options) != 4 do
            IO.warn("Question #{index} does not have exactly 4 options, skipping...")
          else
            attrs = %{
              question: question_data["question"],
              option_1: Enum.at(options, 0),
              option_2: Enum.at(options, 1),
              option_3: Enum.at(options, 2),
              option_4: Enum.at(options, 3),
              correct_answer: question_data["correct_answer"],
              motivation: question_data["motivation"]
            }

            case Repo.insert(Question.changeset(%Question{}, attrs)) do
              {:ok, _question} ->
                if rem(index, 50) == 0 do
                  IO.puts("Inserted #{index} questions...")
                end

              {:error, changeset} ->
                IO.warn("Failed to insert question #{index}: #{inspect(changeset.errors)}")
            end
          end
        end)

        count = Repo.aggregate(Question, :count)
        IO.puts("\n✓ Successfully seeded database with #{count} questions!")

      {:error, reason} ->
        IO.puts("Error parsing JSON: #{inspect(reason)}")
    end

  {:error, reason} ->
    IO.puts("Error reading seeding.json: #{inspect(reason)}")
end
