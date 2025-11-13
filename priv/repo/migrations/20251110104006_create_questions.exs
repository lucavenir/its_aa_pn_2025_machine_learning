defmodule AiQuizzer.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :text, null: false
      add :option_1, :string, null: false
      add :option_2, :string, null: false
      add :option_3, :string, null: false
      add :option_4, :string, null: false
      add :correct_answer, :string, null: false
      add :motivation, :text, null: false

      timestamps(type: :naive_datetime)
    end

    create index(:questions, [:id])
  end
end
