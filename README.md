# Investigating Affective States with Music

With this project we aim to find the effect music has on an individual's affective states. 

## Table of Contents
1. Dataset Generation
2. Classification Models
  2.1 Supervised Model
  2.2 Unsupervised Model
4. Statistical Inference
5. Tools
6. Frontend

## 1. Dataset Generation

To create the dataset, songs can be sourced from either Spotify music library or last.fm website. In this code base, there are two folders available under src/main/datasets. src/main/datasets/last.fm folder contains a python script for connecting to the last.fm API by providing a URL as a system argument. The songs returned by last.fm are searched for in Spotify library and the audio features for matching ones are collected.

Command to source songs and audio features based on last.fm playlists:

```
python last_fm_dataset.py "https://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=Energetic&api_key=0d5cf010febef894eb16adda9a85b41e&format=json" energetic_songs.csv
```

Command to source songs and audio features from Spoitfy:

```
python dataset-create.py
```

## 2. Classification Model

### 2.1 Supervised Model

The jupyter notebook Keras_Classification.ipynb under src/main/classification/supervised contains the code for training a multi-class multi-layer neural network for predicting labels for any new songs. The file can be opened in Google colab and run. A small snapshot of the file needed for training the model has been uploaded in the same folder.

### 2.2 Unsupervised Model

Birch clustering.ipynb under src/main/classification/unsupervised contains the files for running BIRCH machine learning model for unsupervised learning. 

Kmeans emotion classification.ipynb under the src/main/classification/unsupervised contains the code for running K-Means algorithm on the un-annoatated dataset.

## 3. Statistical Inference

Steps Explained : Source File Raw - Music_Emotion Survey Results Hypothesis for each respective emotion class is constructed in a seperate tab. Include this in a tabular format in the deck. (1 slide) Each emotion class basic stats is derived and plotted as box plots. Include the snapshot and box plots in deck (either 1 or 2 or 4 slides). Refer to stats and boxplot folder Step 4 purpose is to illustrate summary statistics and visualization. As we are conducting One-way ANOVA and t-test on multiple means across time points within subjects, we check for the normality assumption for each emotional state. Refer to QQ plot folder. For angry and fearful, the points lie on the reference line. We also checked for outliers - refer to R-Code folder for interpretation Conclude with t-test, generally the results were a mix of p<0.005 and p > 0.005. (I will need to research a bit on the interpretation of this conclusion)

## 4. Tools

The folder src/main/tools contains the following files:

1. youtube_extract.py: Code to generate 1 minute audio clips with .mp3 extension using YouTube links as input. The links are input from a .csv file. The file youtube_links.csv is an example of the expected format.

Installing dependencies:

```
pip install ffmpeg
pip install pytube
```

To run the file, we need to pass a .csv file with youtube links as an argument.

```
python youtube_extract.py youtube_links.csv
```

2. fade.py: fade.py is used to fade the audio clips at the end once they are generated.

Dependencies installation:

```
pip install pydub
```

To run the file, we need to pass the folder containing the audio clips which needs to be clipped and the output folder where we want to store the faded songs.

```
python fade.py Energetic_en Energetic_en_fade
```

3. Survey_responses_preprocessing.ipynb: This jupyter notebook is used to combine the responses received from the participants with the audio features of the songs they listened to. 

## 5. Frontend

The frontend for this survey is a react application which has been deployed using the Firebase hosting services. The frontend comprises of HTML, CSS and Javascript elements. The frontend has been connected to the backend of the survey which is a real-time database on Firebase.
