from fastapi import FastAPI

from dotenv import load_dotenv
load_dotenv("../.env")
from api.routes.ai_routes import ai_router


app = FastAPI()

app.include_router(ai_router, prefix = "/api/ai")
