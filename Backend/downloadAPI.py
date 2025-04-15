# pylint: skip-file

import yt_dlp
import uuid
import os

def downloadVideo(url: str) -> str:
    output_filename = f"{uuid.uuid4()}.mp4"

    ydl_opts = {
        'format': 'bestvideo[height=1080]+bestaudio/best[height=1080]',
        'outtmpl': output_filename,
        'merge_output_format': 'mp4',
        'quiet': True,
    }

    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download([url])

    return output_filename
