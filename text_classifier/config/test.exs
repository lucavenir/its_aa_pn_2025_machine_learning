import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :text_classifier, TextClassifierWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "l3Ncbts1IqP3pFhe86VTQJrrYEoaDNzkDSAS+TMCUtxNMMpRgRwpSuUcoNvjN0gx",
  server: false

# In test we don't send emails
config :text_classifier, TextClassifier.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
