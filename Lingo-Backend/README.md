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

# Chat History

## GET `localhost:8000/api/ai/new-chat`
Create new chat
### Response body
```json
{
  "chatId": "683c3b6d98eebeb3b400d67c"
}
```

## POST `localhost:8000/api/ai/chat/kokoro/{chat_id}`
### Request body
```json
{
  "role": "user",
  "text": "chat message"
}
```
### Response Body
```json
{
  "text": "full_text",
  "final_audio_file": "/assets/tts/134321234.wav",
}
```

## GET `localhost:3000/api/v1/chat`
Get all chat
### Response body
```json
[
    {
        "_id": "683c28875efaea1b45f8f3b4",
        "chat": [
            {
                "role": "user",
                "message": "Hi",
                "_id": "683c29135eb4443fb62cd338"
            },
            {
                "role": "model",
                "message": "Hello, how are you doing?",
                "audio": "/assets/tts/d4b5e68d.wav"
                "_id": "683c29ae6c71ba652a990487"
            }
        ],
        "createdAt": "2025-06-01T10:16:39.589Z",
        "updatedAt": "2025-06-01T10:21:34.511Z",
        "__v": 0
    },
]
```
