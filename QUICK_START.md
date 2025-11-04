# 🚀 Quick Start Guide

## Prerequisites
- Elixir 1.15+ installed
- PostgreSQL 16+ running
- Phoenix Framework archive installed

## Running the Application

### 1. Navigate to the project
```bash
cd quiz_app
```

### 2. Start the server
```bash
mix phx.server
```

### 3. Open your browser
Navigate to: **http://localhost:4000**

---

## That's it! 🎉

The quiz will automatically:
1. Create a new quiz attempt
2. Load all 10 questions
3. Guide you through the quiz with validation
4. Calculate your score
5. Show comprehensive feedback comparing your reasoning with expert rationales

---

## Database Management

### View the database
```bash
cd quiz_app
mix ecto.gen.migration view_questions
```

### Reset everything (if needed)
```bash
cd quiz_app
mix ecto.drop
mix ecto.create
mix ecto.migrate
mix run priv/repo/seeds.exs
```

---

## Troubleshooting

### Port already in use?
Change the port in `config/dev.exs`:
```elixir
config :quiz_app, QuizAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4001], # Change 4000 to 4001
```

### Database connection error?
Check PostgreSQL credentials in `config/dev.exs`:
```elixir
config :quiz_app, QuizApp.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "quiz_app_dev",
```

---

## Testing the Quiz

1. **Take the quiz**: Answer all 10 questions with both multiple choice and justification
2. **Try validation**: Attempt to proceed without completing both inputs (button will be disabled)
3. **Review results**: After submission, see your score and detailed feedback
4. **Retake**: Click "Take Quiz Again" to start a new attempt

---

Enjoy the quiz! 📚✨
