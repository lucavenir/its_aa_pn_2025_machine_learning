defmodule TextClassifierWeb.ClassifierController do
  use TextClassifierWeb, :controller

  def classify(conn, params) do
    input = Map.get(params, "text")
    output = TextClassifier.Classifier.classify(input)
    send_resp(conn, 200, "il risultato è: #{output.label}")
  end
end
