# **\[Application Name Placeholder \- Quiz Application\]**

## **1\. Goal and Scope**

**Goal:** To develop a single-session, client-side assessment tool that presents users with a 10-question multiple-choice quiz. The application will require users to provide a written motivation for each answer and will provide immediate, detailed feedback upon submission.

**Scope:**

* **Core Task:** Present 10 random questions from a pre-defined database.  
* **User Interaction:** Collect one selected answer and one written motivation for each of the 10 questions.  
* **Feedback:** Immediately score the quiz and display correct answers and correct motivations.  
* **Data:** The application is purely front-end. It will not store, track, or transmit any user-generated data (answers, motivations, scores) after the session. It will store the questions only.

## **2\. Data Structures**

**2.1. Question Data Structure (Source)**

All questions loaded by the application must adhere to the following strict JSON schema:

* question (string): The text of the question.  
* options (array of strings): Exactly four strings representing the possible answers.  
* correct\_answer (string): The string text of the one correct option. This must be an exact match to one of the strings in the options array.  
* motivation (string): A detailed explanation for why the correct\_answer is correct and/or why the other options are incorrect.

**Example Object:**

{  
  "question": "According to the text, what is a vector?",  
  "options": \[  
    "A grid of numbers, like a spreadsheet",  
    "A cluster of common information that describes a single point of data",  
    "A mathematical operation that tells how aligned two points are",  
    "The rate of change of a function at a given point"  
  \],  
  "correct\_answer": "A cluster of common information that describes a single point of data",  
  "motivation": "The source material defines a vector as a 'cluster of common information that describes a single point of data,' using the example of a student's attributes \[19, 12, 88\]. A grid of numbers is a matrix, an operation for alignment is a dot product, and the rate of change is a derivative."  
}

**2.2. User Attempt State (In-Memory)**

To manage the user's progress during the session, the application must maintain an in-memory state for each of the 10 questions, tracking:

* The original Question object.  
* The user's selected answer (string).  
* The user's written motivation (string).

## **3\. User Interface (UI) Requirements**

**3.1. Quiz View (Pre-Submission)**

* **Layout:** All 10 questions must be presented to the user.  
* **Per-Question Block:** Each question block must contain:  
  * The question text.  
  * The four options, presented as selectable inputs (e.g., radio buttons). Only one option can be selected at a time.  
  * A text input field (e.g., \<textarea\>) for the user's "Motivation/Reasoning". This field is mandatory.  
* **Submission Button:** A "Submit Quiz" button must be visible.

**3.2. Results View (Post-Submission)**

* This view replaces the Quiz View immediately after a valid submission.  
* **Final Score:** A final score (e.g., "8/10") must be prominently displayed at the top of the view.  
* **Per-Question Feedback:** The view must repeat all 10 questions, each with a detailed feedback block containing:  
  * The question text.  
  * The user's selected answer.  
  * The user's written motivation.  
  * The correct\_answer, clearly highlighted (e.g., with a green color or icon).  
  * The official motivation from the question data structure, displayed for user review.  
  * If the user's answer was incorrect, their selected answer should be clearly marked as incorrect (e.g., with a red color or icon).

## **4\. Submission and Scoring Logic**

**4.1. Submission Validation**

* The "Submit Quiz" button must be disabled by default.  
* The button shall only become enabled when the application state confirms that **all 10 questions** have:  
  1. A selected answer (one of the four options).  
  2. A non-empty string in the "Motivation/Reasoning" text field.  
* Clicking the enabled button triggers the scoring logic and transitions the UI to the Results View.

**4.2. Scoring Logic**

* Scoring is performed immediately on the client-side upon submission.  
* A counter for the final score is initialized to 0\.  
* The system iterates through the user's 10 answers.  
* For each question, it compares the string of the user's selected answer against the correct\_answer string from the question object.  
* If the strings match exactly, **1 point** is added to the final score.  
* If the strings do not match, **0 points** are added.  
* The user's written motivation does not influence the score.  
* The maximum possible score is 10\.

## **5\. Persistence and Data Handling**

* **Question Source:** The application will load questions from a seeded SQL database (e.g., from a large json file). On load, it will randomly select exactly 10 questions for the user's session.  
* **No User Data Persistence:** This is a stateless, single-session tool. The application **must not** store any user-generated data (answers, motivations, scores, or question history) in any persistent storage.  
  * **Prohibited:** localStorage, sessionStorage, cookies, IndexedDB.  
  * **Prohibited:** Sending user data to any server or database.  
* **Session Data:** User answers and motivations will be held only in the active browser memory (e.g., component state) and must be discarded when the page is closed or reloaded.