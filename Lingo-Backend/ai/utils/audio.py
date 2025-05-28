from pydub import AudioSegment
from uuid import uuid4

def combine_wav(file_list: list[str]) -> str:
    combined = AudioSegment.from_wav(file_list[0])
    for file in file_list[1:]:
        audio = AudioSegment.from_wav(file)
        combined += audio

    file_name = f"{uuid4()}.wav"
    combined.export(file_name, format="wav")
    return file_name
