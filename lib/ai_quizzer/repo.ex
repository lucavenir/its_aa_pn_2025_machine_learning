defmodule AiQuizzer.Repo do
  use Ecto.Repo,
    otp_app: :ai_quizzer,
    adapter: Ecto.Adapters.Postgres
end
