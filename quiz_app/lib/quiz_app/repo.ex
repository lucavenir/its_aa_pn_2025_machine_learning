defmodule QuizApp.Repo do
  use AshPostgres.Repo,
    otp_app: :quiz_app

  def installed_extensions do
    # Add postgres extensions needed for Ash features
    ["ash-functions"]
  end

  def min_pg_version do
    %Version{major: 16, minor: 0, patch: 0}
  end
end
