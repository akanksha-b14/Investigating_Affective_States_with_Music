import csv
import pandas as pd 


happy = pd.read_csv('happy_songs.csv')
sad = pd.read_csv('sad_songs.csv')
energetic = pd.read_csv('energetic_songs.csv')
calm = pd.read_csv('calm_songs.csv')

songs = pd.concat([happy,sad,energetic,calm],ignore_index=True,sort=False)

songs.to_csv('last_fm_song_features.csv',encoding='utf-8')
