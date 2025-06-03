print("kokoro module")
from datetime import time
from kokoro import KPipeline
from pydub.audio_segment import os
import soundfile as sf
import torch
from uuid import uuid4
from utils.audio import combine_wav
from utils.files import delete_files

pipeline = KPipeline(lang_code='a')
print("kokoro loaded!")

tts_folder_path = os.environ.get("TTS_FOLDER_PATH") or "."

def kokoro_generate_audio(text: str):
    generator = pipeline(text, voice='af_heart')

    id = uuid4().__str__().split("-")[0]

    files: list[str] = []

    for i, (gs, ps, audio) in enumerate(generator):
        print(i, gs, ps)
        sf.write(f'{tts_folder_path}/{id}-{i}.wav', audio, 24000)
        files.append(f'{tts_folder_path}/{id}-{i}.wav')

    file = combine_wav(files)
    delete_files(files)

    return file
