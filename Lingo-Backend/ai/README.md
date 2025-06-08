# AI Chat

## GET `localhost:8000/api/ai/chat/new/{userId}`
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

## GET `localhost:3000/api/v1/chat/from-user/:userId`
Get all chat
### Response body
```json
[
    {
        "_id": "683c28875efaea1b45f8f3b4",
        "userId": "683c28875efaea1b45f8f3b4",
        "chat": [
            {
                "role": "user",
                "message": "Hi",
                "_id": "683c29135eb4443fb62cd338"
            },
            {
                "role": "model",
                "message": "Hello, how are you doing?",
                "audio": "/assets/tts/d4b5e68d.wav",
                "_id": "683c29ae6c71ba652a990487",
            }
        ],
        "createdAt": "2025-06-01T10:16:39.589Z",
        "updatedAt": "2025-06-01T10:21:34.511Z",
        "__v": 0
    },
]
```
