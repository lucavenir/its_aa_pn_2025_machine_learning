# **Software Requirements Document: Justification Quiz Engine**

## **1\. Application Overview and Goal**

The primary goal of this application is to provide a **single-session, high-stakes self-assessment tool** that requires users to actively engage with the material by **justifying** their answers. This application is designed purely for self-testing and immediate informational feedback.

The application must be **stateless** and maintain absolute **privacy**. Upon quiz submission or completion, the application **MUST NOT** store, record, or track any user-generated data, including selected options, provided textual justifications (motivations), calculated scores, or time taken. The application's lifecycle is limited to the single session on the user's screen.

## **2\. Quiz Generation and Structure**

### **2.1 Quiz Content Selection**

The system shall randomly select and display precisely **ten (10)** questions from the application’s large, pre-existing database for each session.

### **2.2 Question Data Structure**

The application must draw from a question bank where each question is structured with the following mandatory fields:

{  
    "question": "string",  
    "options": \["string", "string", "string", "string"\],  
    "correct\_answer": "string",  
    "motivation": "string"  
}

The correct\_answer field must match one of the strings provided in the options array. The motivation field contains the definitive explanation for the correct answer.

### **2.3 Quiz Display**

The 10 selected questions shall be presented sequentially or on a single page, ensuring clear separation between each question.

## **3\. User Interaction and Validation**

### **3.1 Mandatory User Inputs**

For each of the ten questions presented, the user shall be required to provide two distinct and mandatory inputs:

1. **Option Selection:** The user must select **precisely one** of the four provided options. This interaction shall be implemented using a radio button group (or equivalent UI component).  
2. **Textual Justification:** The user must provide a **textual justification (motivation)** for their chosen answer. This interaction shall be implemented using a text area input field.

### **3.2 Submission Gate**

A primary "Submit Quiz" button shall be prominently displayed but must remain **disabled** until the following validation criteria are met for **all 10 questions**:

* Criterion A: A single option has been selected.  
* Criterion B: Textual content has been provided in the justification input field.

The submission button must become enabled only when both Criterion A and Criterion B are satisfied for every question.

## **4\. Results and Feedback**

### **4.1 Post-Submission Output**

Upon successful submission, the system shall transition to a results view. The **only** information presented to the user for each of the 10 questions shall be:

1. The **Correct Answer**: Displaying the string value found in the database's correct\_answer field.  
2. The **Definitive Explanation**: Displaying the full text found in the database's motivation field.

### **4.2 Scoring Policy**

The application **MUST NOT** calculate, display, or communicate any score, grade, or pass/fail status to the user. The application's role is purely to provide the correct information for self-correction.