import spotipy
import spotipy.util as util
import spotipy.oauth2 as oauth2
import pandas as pd
from spotipy.oauth2 import SpotifyClientCredentials

CLIENT_ID = #YOUR CLIENT_ID
CLIENT_SECRET = #YOUR CLIENT_SECRET

client_credentials_manager = SpotifyClientCredentials(client_id=CLIENT_ID, client_secret=CLIENT_SECRET)
sp = spotipy.Spotify(client_credentials_manager=client_credentials_manager)

##English song dataset generation
#Happy
happy = "2MOtMdv1xDmKseMHwPZLpc"
#sad
sad = "3CfQlMNi5zQ6mrDqx56GXT"
#calm
calm = "1ofJSOJDpcRRBW6tMOyfdv"
#energetic
energetic = "3WYmyXrEqRL1UnV3ep13ie"

def analyze_playlist(creator, playlist_id,label):
    
    # Create empty dataframe
    playlist_features_list = ["id","artist", "album", "name", "length",	
                                "danceability","acousticness", "energy", "instrumentalness", "liveness", "valence",	"loudness",	"speechiness", "tempo", "key","time_signature","mood"]
    playlist_dataframe = pd.DataFrame(columns = playlist_features_list)
    
    playlist_features = {}
    
    # Loop through every track in the playlist, extract features and append the features to the playlist df
    tracks = sp.user_playlist_tracks(creator, playlist_id)
    playlist = tracks['items']
    while tracks['next']:
        tracks = sp.next(tracks)
        playlist.extend(tracks['items'])

    for track in playlist:
        # Get metadata
        
        playlist_features["artist"] = track["track"]["album"]["artists"][0]["name"]
        playlist_features["album"] = track["track"]["album"]["name"]
        playlist_features["name"] = track["track"]["name"]
        playlist_features["mood"] = label
        playlist_features["id"] = track["track"]["id"]
        playlist_features["length"]=track["track"]["duration_ms"]
        # Get audio features
        audio_features = sp.audio_features([track["track"]["id"]])[0]
        for feature in playlist_features_list[5:-1]:
            playlist_features[feature] = audio_features[feature]
        # Concat the header and the rows dfs
        track_dataframe = pd.DataFrame(playlist_features, index = [0])
        playlist_dataframe = pd.concat([playlist_dataframe, track_dataframe], ignore_index = True)
        
    return playlist_dataframe


happy = analyze_playlist("Playlist Manager",happy,"Happy")
sad = analyze_playlist("Playlist Manager",sad,"Sad")
energetic = analyze_playlist("Playlist Manager",energetic,"Energetic")
calm = analyze_playlist("Calm",calm,"Calm")

all_songs = pd.concat([happy,sad,energetic,calm],ignore_index=True,sort=False)
all_songs.to_csv('english_songs_new.csv',encoding='utf-8')
