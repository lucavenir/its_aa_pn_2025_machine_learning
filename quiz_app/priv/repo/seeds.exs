# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QuizApp.Repo.insert!(%QuizApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias QuizApp.Quiz.Question

# Clear existing questions (useful for re-running seeds)
Question
|> Ash.Query.for_read(:read)
|> Ash.read!()
|> Enum.each(&Ash.destroy!/1)

# Question 1: Design Principles
Question.create!(%{
  question_id: "q1",
  display_order: 1,
  question_text:
    "Which principle of design emphasizes the distribution of visual weight in a composition?",
  options: [
    "Contrast",
    "Balance",
    "Rhythm",
    "Unity"
  ],
  correct_option_index: 1,
  expert_rationale:
    "Balance refers to the distribution of visual weight in a composition. It can be symmetrical (formal balance) or asymmetrical (informal balance). When elements are balanced, the composition feels stable and harmonious. This is distinct from contrast (which emphasizes differences), rhythm (which creates movement through repetition), and unity (which creates cohesiveness)."
})

# Question 2: Critical Thinking
Question.create!(%{
  question_id: "q2",
  display_order: 2,
  question_text:
    "In logical reasoning, what type of argument moves from specific observations to broad generalizations?",
  options: [
    "Deductive reasoning",
    "Inductive reasoning",
    "Abductive reasoning",
    "Analogical reasoning"
  ],
  correct_option_index: 1,
  expert_rationale:
    "Inductive reasoning starts with specific observations and measures, then detects patterns and regularities to formulate tentative hypotheses, and finally develops general conclusions or theories. This is the opposite of deductive reasoning, which starts with a general statement and examines the possibilities to reach a specific, logical conclusion. Abductive reasoning involves forming a conclusion from the information that is known, and analogical reasoning draws comparisons between two similar situations."
})

# Question 3: Color Theory
Question.create!(%{
  question_id: "q3",
  display_order: 3,
  question_text:
    "What are the three primary colors in the subtractive color model (used in painting and printing)?",
  options: [
    "Red, Green, Blue",
    "Cyan, Magenta, Yellow",
    "Red, Yellow, Blue",
    "Orange, Purple, Green"
  ],
  correct_option_index: 1,
  expert_rationale:
    "In the subtractive color model (CMYK), used in painting and printing, the primary colors are Cyan, Magenta, and Yellow. These colors absorb (subtract) certain wavelengths of light and reflect others. When combined, they theoretically create black (in practice, black ink is added as 'K'). This is different from the additive color model (RGB) used in digital displays, where Red, Green, and Blue light combine to create white. The traditional artist's primaries of Red, Yellow, and Blue are a simplified approximation."
})

# Question 4: Scientific Method
Question.create!(%{
  question_id: "q4",
  display_order: 4,
  question_text: "What is the primary purpose of a control group in an experimental study?",
  options: [
    "To increase the sample size",
    "To provide a baseline for comparison",
    "To eliminate all variables",
    "To prove the hypothesis correct"
  ],
  correct_option_index: 1,
  expert_rationale:
    "A control group provides a baseline for comparison by not receiving the experimental treatment. This allows researchers to isolate the effect of the independent variable by comparing results between the experimental group (which receives the treatment) and the control group (which does not). The control group helps ensure that observed changes are due to the treatment rather than other factors. It's not meant to increase sample size, eliminate all variables (which is impossible), or prove the hypothesis correct (science tests hypotheses, it doesn't 'prove' them)."
})

# Question 5: Typography
Question.create!(%{
  question_id: "q5",
  display_order: 5,
  question_text: "What is the term for the vertical space between lines of text?",
  options: [
    "Kerning",
    "Tracking",
    "Leading",
    "Baseline"
  ],
  correct_option_index: 2,
  expert_rationale:
    "Leading (pronounced 'ledding') refers to the vertical space between lines of text, measured from baseline to baseline. The term originates from the strips of lead that printers used to place between lines of metal type. Proper leading improves readability by preventing lines from appearing too cramped or too sparse. Kerning adjusts space between individual letter pairs, tracking adjusts space uniformly across text, and baseline is the invisible line on which letters sit."
})

# Question 6: Problem Solving
Question.create!(%{
  question_id: "q6",
  display_order: 6,
  question_text:
    "Which problem-solving strategy involves working backward from the desired goal to determine the steps needed?",
  options: [
    "Trial and error",
    "Means-end analysis",
    "Algorithm",
    "Heuristic"
  ],
  correct_option_index: 1,
  expert_rationale:
    "Means-end analysis is a problem-solving strategy that works backward from the desired goal (the 'end') to identify the 'means' or steps needed to reach it. At each stage, you identify the difference between your current state and the goal state, then select actions to reduce that difference. This is different from trial and error (randomly trying solutions), algorithms (step-by-step procedures that guarantee a solution), and heuristics (mental shortcuts that may or may not work)."
})

# Question 7: Visual Hierarchy
Question.create!(%{
  question_id: "q7",
  display_order: 7,
  question_text:
    "Which design element is most effective for creating visual hierarchy and directing viewer attention?",
  options: [
    "Color saturation",
    "Size and scale",
    "Texture",
    "Pattern"
  ],
  correct_option_index: 1,
  expert_rationale:
    "Size and scale are the most effective elements for creating visual hierarchy. Larger elements naturally draw attention first and are perceived as more important. Our eyes are attracted to size differences before processing other attributes. While color saturation, texture, and pattern can contribute to hierarchy, size and scale provide the most immediate and powerful way to establish importance and guide the viewer's eye through a composition in a specific order."
})

# Question 8: Data Analysis
Question.create!(%{
  question_id: "q8",
  display_order: 8,
  question_text:
    "What statistical measure represents the middle value when data is arranged in order?",
  options: [
    "Mean",
    "Median",
    "Mode",
    "Range"
  ],
  correct_option_index: 1,
  expert_rationale:
    "The median is the middle value in a dataset when arranged in numerical order. If there's an odd number of values, it's the exact middle one; if even, it's the average of the two middle values. The median is particularly useful because it's not affected by extreme outliers, unlike the mean (average). The mode is the most frequently occurring value, and range is the difference between the highest and lowest values. For skewed distributions, median often provides a better representation of the 'typical' value than mean."
})

# Question 9: Gestalt Principles
Question.create!(%{
  question_id: "q9",
  display_order: 9,
  question_text:
    "According to Gestalt psychology, which principle explains why we perceive objects that are close together as belonging to a group?",
  options: [
    "Similarity",
    "Proximity",
    "Continuity",
    "Closure"
  ],
  correct_option_index: 1,
  expert_rationale:
    "The principle of Proximity states that objects placed close together are perceived as a group or unit. This fundamental Gestalt principle explains how spatial relationships influence perception. Our brain automatically groups nearby elements, assuming they are related. This is distinct from Similarity (grouping similar-looking objects), Continuity (preferring smooth, continuous paths), and Closure (completing incomplete shapes). Proximity is one of the strongest and most commonly applied principles in design."
})

# Question 10: Logical Fallacies
Question.create!(%{
  question_id: "q10",
  display_order: 10,
  question_text:
    "What logical fallacy occurs when someone argues that a claim must be true simply because it hasn't been proven false?",
  options: [
    "Ad hominem",
    "Appeal to ignorance",
    "Slippery slope",
    "False dichotomy"
  ],
  correct_option_index: 1,
  expert_rationale:
    "Appeal to ignorance (argumentum ad ignorantiam) is the fallacy that occurs when someone argues that a proposition is true because it has not been proven false (or vice versa). The absence of evidence is not evidence of absence. This fallacy shifts the burden of proof incorrectly. Ad hominem attacks the person rather than the argument, slippery slope assumes one event will lead to a chain of events, and false dichotomy presents only two options when more exist. Understanding this fallacy is crucial for critical thinking and evaluating arguments."
})

IO.puts("\n✅ Successfully seeded 10 quiz questions!")
