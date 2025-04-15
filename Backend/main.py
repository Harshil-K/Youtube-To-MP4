# pylint: skip-file

from fastapi import FastAPI
from fastapi.responses import FileResponse
from pydantic import BaseModel
from Backend.downloadAPI import downloadVideo
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles


import uuid

app = FastAPI()

class URLRequest(BaseModel):
    url: str

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://localhost:3000"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.post("/download")
async def download(data: URLRequest):
    filename = downloadVideo(data.url)
    return FileResponse(filename, media_type="video/mp4", filename="video.mp4")

app.mount("/", StaticFiles(directory="Frontend", html=True), name="Frontend")

@app.get("/")
async def serve_home():
    return FileResponse("Frontend/index.html")