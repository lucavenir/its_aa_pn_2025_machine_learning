defmodule TextClassifier.Classifier do
  def classify(input) when is_binary(input) do
    {:ok, model_info} =
      Bumblebee.load_model({:hf, "finiteautomata/bertweet-base-emotion-analysis"})

    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "vinai/bertweet-base"})

    serving =
      Bumblebee.Text.text_classification(model_info, tokenizer,
        top_k: 1,
        compile: [batch_size: 1, sequence_length: 100],
        defn_options: [compiler: EXLA]
      )

    output = Nx.Serving.run(serving, input)
    List.first(output.predictions)
  end
end
