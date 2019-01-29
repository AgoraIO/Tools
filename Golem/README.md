# Getting Started
Golem is a tool to fake user(s) in Agora channel running on Linux x64(verified on ubuntu & centos).
## Features
* Read yuv file and send video stream.
* Read pcm file and send audio stream.
## Build
1. Download Agora linux native SDK, Extract it.
2. Copy include/ to Golem/include
3. Copy libs/ to Golem/libs
4. make
``` bash
make clean 
make
```
## Configuration
### In config.json
* **key** : String, Specifies appID, you can get it from [here](http://agora.io).
* **channel_name** : String, Specifies the channel name.
* **uid** : Integer, Specifies the uid except 0. Golem will get dynamic uid from SDK if set uid 0.
* **video_file** : String, Specifies the yuv file path. example:
``` json
"video_file":"/home/username/Tools/Golem/input.yuv"
```
* **audio_file** : String, Specifies the pcm file path. example:
``` json
"audio_file":"/home/username/Tools/Golem/input.pcm"
```
## Run
* export the Golem/libs to LD_LIBRARY_PATH. example:
``` bash
export LD_LIBRARY_PATH=/home/username/Tools/Golem/libs:$LD_LIBRARY_PATH
```

```
python ./golem_run.py
```
## Get AppID
You can get your appID on Agora developer dashboard (http://dashboard.agora.io).
## video profile list
| index     |  res       | fps   |  kbps  |
| --------- | :-------:  | :-----: | ------: |
| 0         | 160x120    |15fps  | 80kbps |
| 1		    | 120x160    |15fps  | 80kbps |
| 2		    | 120x120    |15fps  | 60kbps |
| 10		| 320x180    |15fps  | 160kbps |
| 11		| 180x320    |15fps  | 160kbps |
| 12		| 180x180    |15fps  | 120kbps |
| 20		| 320x240    |15fps  | 200kbps |
| 21		| 240x320    |15fps  | 200kbps |
| 22		| 240x240    |15fps  | 160kbps |
| 30		| 640x360    |15fps  | 400kbps |
| 31		| 360x640    |15fps  | 400kbps |
| 32		| 360x360    |15fps  | 300kbps |
| 33		| 640x360    |30fps  | 800kbps |
| 34		| 360x640    |30fps  | 800kbps |
| 35		| 360x360    |30fps  | 600kbps |
| 40		| 640x480    |15fps  | 500kbps |
| 41		| 480x640    |15fps  | 500kbps |
| 42		| 480x480    |15fps  | 400kbps |
| 43		| 640x480    |30fps  | 1000kbps |
| 44		| 480x640    |30fps  | 1000kbps |
| 45		| 480x480    |30fps  | 800kbps |
| 50		| 1280x720   |15fps  | 1000kbps |
| 51		| 720x1280   |15fps  | 1000kbps |
| 52		| 1280x720   |30fps  | 2000kbps |
| 53		| 720x1280   |30fps  | 2000kbps |
| 60		| 1920x1080  |15fps  | 1500kbps |
| 61		| 1080x1920  |15fps  | 1500kbps |
| 62		| 1920x1080  |30fps  | 3000kbps |
| 63		| 1080x1920  |30fps  | 3000kbps |
| 64		| 1920x1080  |60fps  | 6000kbps |
| 65		| 1080x1920  |60fps  | 6000kbps |
| 70		| 3840x2160  |30fps  | 8000kbps |
| 71		| 2160x3080  |30fps  | 8000kbps |
| 72		| 3840x2160  |60fps  | 16000kbps |
| 73		| 2160x3840  |60fps  | 16000kbps |
