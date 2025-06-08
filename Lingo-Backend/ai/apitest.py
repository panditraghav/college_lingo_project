import os
from google import genai
from google.genai import types
from dotenv import load_dotenv
import asyncio

load_dotenv("../.env")

client = genai.Client(api_key=os.environ["GOOGLE_AI_STUDIO_KEY"])


async def get_response():
    async for chunk in await client.aio.models.generate_content_stream(
        model='gemini-2.0-flash-001', contents='Tell me a story in 200 words.'
    ):
        print(chunk.text, end='')


asyncio.run(get_response())
