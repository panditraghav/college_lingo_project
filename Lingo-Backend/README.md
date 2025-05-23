# Backend
Backend readme update

## GET `/api/grammar-lessons`
### Response
```json
[
  {
    "id": "chapterid",
    "name": "chaptername",
    "subtopics": [
      {
        "id": "subtopicid",
        "name": "chaptername",
        "completed": "true"
      }
    ]
  },
  ...
]
```

## GET `/api/grammar-lessons/sub-topic/:id`
returns topic content in markdown format
### Response
```json
{
  "title": "Forming Positive Sentences",
  "content": "Subject + base verb (s/es)..."
}
```

## GET `/api/quizz/grammar/:subtopic_id`
Choose one of the many pregenerated quizz papers for the topic (but not the one already took)
### Response
```json
{
  "id": "quizid",
  "Questions": [
    {
      "Question": ".....",
      "Choices": ["1....", "2...", "3..", "4.."],
      "Answer": 3
    }
  ]
}
```

## POST `/api/quizz/:subtopic_id`
We need to store the quizzes which are taken so that we won't send the same quizz again,
if the user retries quizz
### Request Body
```json
{
  "quizz_id": "324qawer21",
  "score": 3
}
```
