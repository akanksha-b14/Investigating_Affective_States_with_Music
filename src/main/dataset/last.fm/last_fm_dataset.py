#Author: Akanksha Bansal

import requests
import spotipy
import spotipy.util as util
import spotipy.oauth2 as oauth2
import pandas as pd
from spotipy.oauth2 import SpotifyClientCredentials
import sys

CLIENT_ID = #INPUT YOUR CLIENT_ID
CLIENT_SECRET = #INPUT YOUR CLIENT_SECRET

client_credentials_manager = SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

#url = "https://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=Energetic&api_key=0d5cf010febef894eb16adda9a85b41e&format=json"
url = sys.argv[1]
result_filename = sys.argv[2]

response = requests.get(url)
result = response.json()
result_albums = result['albums']['album']

totalPages = int(result['albums']['@attr']['totalPages'])

def get_all_songs(totalPages,result_albums):
    count = 1
    while count <= totalPages:
        count = count + 1
        url_new = url+"&page="+str(count)
        response = requests.get(url_new)
        result = response.json()
        result_albums = result_albums + result['albums']['album']
    return result_albums

if totalPages>1:
    result_albums = get_all_songs(totalPages, result_albums)

playlist_features_list = ["label","id","last.fm.artist","last.fm.track","artist","track_name","length", "acousticness",
                             "danceability", "energy", "key", "loudness", "mode", "speechiness",
                             "instrumentalness", "liveness", "valence", "tempo",'time_signature']

playlist_dataframe = pd.DataFrame(columns = playlist_features_list)

playlist_features = {}

track_ids = []

for song in result_albums:
    artist_fm = song['artist']['name']
    track_fm = song['name']
    searchResults = sp.search(q="artist:" + artist_fm + " track:" + track_fm, type="track")
    if(searchResults['tracks']['total']!=0):
        items = searchResults['tracks']['items']
        for track in items:
            spotify_artist = track["album"]["artists"][0]["name"]
            spotify_track = track["name"]
            if((spotify_artist.lower()==artist_fm.lower() and spotify_track.lower()==track_fm.lower()) or ((spotify_track.lower() in track_fm.lower()) or (track_fm.lower() in spotify_track.lower())) and track["id"] not in track_ids):
                print(spotify_track,spotify_artist)
                playlist_features["artist"] = spotify_artist
                playlist_features["track_name"] = spotify_track
                playlist_features['label']="Energetic"
                playlist_features['last.fm.artist']=artist_fm
                playlist_features['last.fm.track']=track_fm
                playlist_features['length']=track["duration_ms"]
                playlist_features["id"]=track["id"]
                track_ids.append(playlist_features["id"])
                audio_features = sp.audio_features([track["id"]])[0]
                for feature in playlist_features_list[7:]:
                    playlist_features[feature] = audio_features[feature]
            
                track_dataframe = pd.DataFrame(playlist_features, index = [0])
                playlist_dataframe = pd.concat([playlist_dataframe, track_dataframe], ignore_index = True)
            break

playlist_dataframe.to_csv(result_filename,encoding='utf-8')
