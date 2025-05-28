import asyncio
from asyncio import Queue
from fastapi import APIRouter, Response, HTTPException, status
from google import genai
from uuid import uuid4
from google.genai.chats import AsyncChat
from google.genai.types import GenerateContentConfig
from pydantic import BaseModel
import os

from utils.files import delete_files
from utils.text_to_speech import generate_audio
from utils.audio import combine_wav
from utils.tts_kokoro import kokoro_generate_audio

ai_router = APIRouter()

chats_dict: dict[str, AsyncChat] = {}

client = genai.Client(api_key=os.environ.get("GOOGLE_AI_STUDIO_KEY"))

@ai_router.get("/new-chat")
def new_chat():
    id = uuid4()
    chats_dict[id.__str__()] = client.aio.chats.create(model='gemini-2.0-flash')
    return {"chatId": id}


class ChatMessage(BaseModel):
    role: str
    text: str

async def audio_consumer(queue: Queue[str], file_paths: list[str]):
    while True:
        item = await queue.get()  # Async get
        print("Got queue item: ", item, sep= "")
        path = generate_audio(item)
        print("Audio generated for: ", item)
        print("Path is: ", path)
        if path != "":
            file_paths.append(path)
        queue.task_done()

default_chat = client.aio.chats.create(model='gemini-2.0-flash', config = GenerateContentConfig(system_instruction= "You are a AI english tutor of Lingo English Learning application, you have to explain all the doubts that the user have. You have to generate text which will be input to a text-to-speech model, so you have to generate text which doesn't have formattings like bullet points, headings, etc. Don't output text in markdown format, just plain text."))

@ai_router.post("/chat/{chat_id}", status_code= status.HTTP_200_OK)
async def post_chat_message(chat_id: str, message: ChatMessage, response: Response):
    print("chat_id: ", chat_id)
    print("Chat message: ", message)
    # current_chat = chats_dict.get(chat_id)
    current_chat = default_chat

    if current_chat == None:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"message": "Chat not found!, please create new chat"}

    queue = asyncio.Queue[str]()
    file_paths: list[str] = []
    consumers = []

    for _ in range(3):
        consumers.append(asyncio.create_task(audio_consumer(queue, file_paths)))

    print("Consumer created!")

    sentence = ""
    full_text = ""
    sentence_send_for_audio_gen_len = 0

    async for chunk in await current_chat.send_message_stream(message.text):
        print("ChunkText: ", chunk.text, end = " ")
        if chunk.text == None:
            continue
        full_text += chunk.text

        full_stop_index = chunk.text.find(".", 0, -1)
        print("full_stop_index: ", full_stop_index)

        if full_stop_index == -1:
            sentence += chunk.text
        else:
            sentence += chunk.text[0:full_stop_index + 1]
            # full_stop_list.append(curr)
            print("Putting sentence into queue: ", sentence, sep ="")
            sentence_send_for_audio_gen_len += len(sentence)
            await queue.put(sentence)
            sentence = chunk.text[full_stop_index + 2: -1]

    if sentence_send_for_audio_gen_len < len(full_text) and sentence.strip() != "":
        await queue.put(sentence)
    await queue.join()
    print(file_paths)

    for consumer in consumers:
        consumer.cancel()

    final_audio_file = combine_wav(file_paths)

    return {"text": full_text,"file_paths": file_paths,"final_audio_file": final_audio_file}

@ai_router.get("/chat/{chat_id}")
def get_chat(chat_id: str):
    return {chat_id: chats_dict.get(chat_id)}


###########################################
# KOKORO
###########################################


async def kokoro_tts_consumer(queue: Queue[str], file_paths: list[str]):
    while True:
        item = await queue.get()  # Async get
        print("(KOKORO) Got queue item: ", item, sep= "")
        path = kokoro_generate_audio(item)
        print("(KOKORO) Audio generated for: ", item)
        print("(KOKORO) Path is: ", path)
        if path != "":
            file_paths.append(path)
        queue.task_done()

@ai_router.post("/chat/kokoro/{chat_id}", status_code= status.HTTP_200_OK)
async def kokoro_post_chat(chat_id: str, message: ChatMessage, response: Response):
    queue = asyncio.Queue[str]()
    file_paths: list[str] = []
    consumers = []

    for _ in range(3):
        consumers.append(asyncio.create_task(kokoro_tts_consumer(queue, file_paths)))
    try: 
        print("Chat message: ", message)
        current_chat = default_chat

        if current_chat == None:
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"message": "Chat not found!, please create new chat"}

        sentence = ""
        full_text = ""
        sentence_send_for_audio_gen_len = 0

        async for chunk in await current_chat.send_message_stream(message.text):
            print("ChunkText: ", chunk.text, end = " ")
            if chunk.text == None:
                continue
            full_text += chunk.text

            full_stop_index = chunk.text.find(".", 0, -1)
            print("full_stop_index: ", full_stop_index)

            if full_stop_index == -1:
                sentence += chunk.text
            else:
                sentence += chunk.text[0:full_stop_index + 1]
                # full_stop_list.append(curr)
                print("Putting sentence into queue: ", sentence, sep ="")
                sentence_send_for_audio_gen_len += len(sentence)
                await queue.put(sentence)
                sentence = chunk.text[full_stop_index + 2: -1]

        if sentence_send_for_audio_gen_len < len(full_text) and sentence.strip() != "":
            await queue.put(sentence)
        await queue.join()
        print(file_paths)

        for consumer in consumers:
            consumer.cancel()

        final_audio_file = combine_wav(file_paths)
        delete_files(file_paths)

        return {"text": full_text, "final_audio_file": final_audio_file}

    except asyncio.CancelledError:
        print("Request cancelled!")
        for consumer in consumers:
            consumer.cancel()
        return {"message": "Request cancelled!"}

    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        for consumer in consumers:
            consumer.cancel()
        raise HTTPException(status_code=500, detail="Internal server error")

