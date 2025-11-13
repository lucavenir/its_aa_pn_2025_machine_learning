# Justification Quiz Engine

A privacy-focused, stateless self-assessment quiz application built with Elixir and Phoenix LiveView. This application requires users to both select an answer AND provide a written justification for each question, promoting active learning through reflection.

## Key Features

- **10 Random Questions**: Each session presents 10 randomly selected questions from a large database
- **Dual Input Required**: Users must both select an option AND provide a textual justification
- **Stateless & Private**: NO user responses are ever stored - everything stays in your browser session
- **Results Review**: After submission, view correct answers and detailed explanations
- **Modern UI**: Built with DaisyUI components for a polished, responsive interface

## Privacy Guarantee

**This application is completely stateless regarding user data:**
- ✅ Questions are stored in the database (read-only)
- ❌ User selections are NEVER stored
- ❌ User justifications are NEVER stored  
- ❌ Scores are NEVER calculated or displayed
- ❌ No tracking, analytics, or data persistence

All user input exists only in the LiveView socket during the session and is cleared when you close the browser.

## Technology Stack

- **Framework**: Phoenix 1.8 with LiveView
- **Language**: Elixir
- **Database**: PostgreSQL (for question storage only)
- **UI**: DaisyUI + Tailwind CSS v4
- **No client-side JavaScript required** (except Phoenix LiveView)

## Getting Started

### Prerequisites

- Elixir 1.14+
- Erlang/OTP 25+
- PostgreSQL (or configure for SQLite)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   mix setup
   ```

3. Create and seed the database:
   ```bash
   mix ecto.create
   mix ecto.migrate
   mix run priv/repo/seeds.exs
   ```

4. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

5. Visit [`localhost:4000`](http://localhost:4000) in your browser

## Adding Questions

Questions are stored in `seeding.json` at the project root. To add new questions:

1. Edit `seeding.json` following this structure:
   ```json
   {
     "question": "Your question text?",
     "options": [
       "Option 1",
       "Option 2", 
       "Option 3",
       "Option 4"
     ],
     "correct_answer": "Option 1",
     "motivation": "Explanation for why Option 1 is correct..."
   }
   ```

2. Re-seed the database:
   ```bash
   mix run priv/repo/seeds.exs
   ```

**Note**: Each question must have exactly 4 options, and `correct_answer` must match one of them exactly.

## Development

### Running Tests

```bash
mix test
```

### Code Quality

Run the precommit checks (formatting, compilation warnings, etc.):
```bash
mix precommit
```

### Project Structure

```
lib/
  ai_quizzer/
    quiz.ex              # Context module for question queries
    quiz/
      question.ex        # Ecto schema for questions
  ai_quizzer_web/
    live/
      quiz_live.ex       # Main LiveView module
      quiz_live.html.heex # Quiz and results templates
```

## How It Works

1. **Quiz Session Start**: 10 random questions are fetched from the database
2. **User Input**: For each question, the user must:
   - Select one of four options (radio button)
   - Write a justification explaining their choice (text area)
3. **Validation**: The "Submit Quiz" button remains disabled until ALL 10 questions have both inputs
4. **Results**: Upon submission, the application displays:
   - The correct answer for each question
   - A detailed explanation/motivation
   - NO score or pass/fail status (purely informational)
5. **New Quiz**: Users can start a new session with 10 different random questions

## Design Philosophy

This application follows a strict "information-only" approach:
- **No scoring**: We don't calculate or display grades
- **No persistence**: User responses vanish after the session
- **Active learning**: Requiring justifications promotes deeper engagement with material
- **Self-assessment**: The goal is reflection, not evaluation

## License

[Your License Here]

## Learn More About Phoenix

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix

