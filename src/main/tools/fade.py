import os
import pydub
from pydub import AudioSegment
import sys

folder_name = sys.argv[1]
output_folder = sys.argv[2]

for filename in os.listdir('./'+folder_name):
    if filename.endswith(".mp3"):
        song = AudioSegment.from_mp3('./'+folder_name+'/'+filename)
        faded_song = song.fade_in(1000).fade_out(3000)
        faded_song.export('./'+output_folder+'/'+filename, format="mp3")
