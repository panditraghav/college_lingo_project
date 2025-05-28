from pydub import AudioSegment
from uuid import uuid4
import os

tts_folder_path = os.environ.get("TTS_FOLDER_PATH") or "."

def combine_wav(file_list: list[str]) -> str:
    combined = AudioSegment.from_wav(file_list[0])
    for file in file_list[1:]:
        audio = AudioSegment.from_wav(file)
        combined += audio

    id = uuid4().__str__().split('-')[0]
    file_name = f"{tts_folder_path}/{id}.wav"
    
    combined.export(file_name, format="wav")
    return file_name
