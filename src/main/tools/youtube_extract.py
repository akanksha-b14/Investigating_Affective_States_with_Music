from pytube import YouTube
import os
import csv
import pandas as pd
import ffmpeg
from moviepy.video.io.ffmpeg_tools import ffmpeg_extract_subclip
import sys

input_file = sys.argv[1]
links_meta = pd.read_csv(input_file)

links_meta_list = links_meta['Links'].values.tolist()

for i in links_meta_list:
    yt = YouTube(i)
    video = yt.streams.filter(only_audio=True).first()
    out_file = video.download(output_path="raw_audio_files_en_energetic")
    
    base, ext = os.path.splitext(out_file)
    new_file = base + '.mp3'
    os.rename(out_file, new_file)

    ffmpeg_cmd = (
            ffmpeg
                .input(new_file, ss=20, t=63)
                .output(base+'_trim.mp3', acodec='mp3')
                .overwrite_output()
        )
    ffmpeg_cmd.run()
    
    
