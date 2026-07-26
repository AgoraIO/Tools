# Agora WebRTC Precall Test
> Have a try @ [https://webdemo.agora.io/agora\_webrtc\_troubleshooting/](https://webdemo.agora.io/agora\_webrtc\_troubleshooting/)  

Use this sample app to check if the following item works for Agora WebRTC before starting a call.

- Browser Compatibility
- Microphone
- Speaker
- Resolution
- Connection
- Camera (optional)

## Build and Run the Sample App

Ensure you have an Agora developer account and an App ID before using this app, see [Agora account management](https://docs.agora.io/en/realtime-media/video/manage-agora-account?platform=web#get-the-app-id) for details.

1.  Set the App ID before starting the app. Set the App Certificate only when
    it is enabled for the project:

    ```bash
    export VUE_APP_AGORA_APP_ID="your-app-id"
    export VUE_APP_AGORA_APP_CERTIFICATE="your-app-certificate" # Optional
    ```

    The app does not provide a default App ID.

    **Security warning:** Vue embeds `VUE_APP_*` values in browser JavaScript.
    When an App Certificate is configured, this setup is for local
    troubleshooting only. Do not deploy it to production or expose a
    production App Certificate. Production applications must generate tokens
    on a trusted server.
2.  Install dependencies:

    `npm install`

3.  To run the app locally:

    `npm run dev`

    Visit `localhost:8080` on your browser.

4.  Build the app for production:

    `npm run build`

    Built files need to be served over an HTTP server.


## How the Sample App Works

The following introduces which APIs are used in each step of the precall test.

### Browser Compatibility

Use `AgoraRTC.checkSystemRequirements` to check if the browser is supported by Agora Web SDK.

```javascript
/** whether your browser fully supports Agora Web SDK */
AgoraRTC.checkSystemRequirements(): boolean
/**
 * some browser info got from
 * object `navigator` in BOM
 */
navigator.appVersion
navigator.appName
```

### Microphone

1.  Use `AgoraRTC.createMicrophoneAudioTrack` to create an audio track.
2.  Use `track.getVolumeLevel` to retrieve the current volume.

```javascript
/** create an audio stream and try to init/play it */
AgoraRTC.createMicrophoneAudioTrack(): Promise<ILocalAudioTrack>
/**
 * accumulate audio level to check
 * if it is in an ideal range
 */
track.getVolumeLevel(): number
```

### Speaker

Use the audio element in HTML5 and let the users confirm whether they hear the sound.

### Resolution

1.  Use `AgoraRTC.createCameraVideoTrack` to create video tracks with different encoder configurations.
2.  Use `HTMLVideoElement` to get the video resolution.

```javascript
/** Create stream with different video profiles */
AgoraRTC.createCameraVideoTrack(): Promise<ILocalVideoTrack>
/** Get actual resolution from html element */
HTMLVideoElement.videoHeight
HTMLVideoElement.videoWidth
```

### Connection

1.  Use `AgoraRTC.createClient` to create a sender client and a receiver client.
2.  Use `AgoraRTC.createMicrophoneAndCameraTracks` to create local tracks.
3.  Use `client.publish` to publish the stream from the sender client.
4.  Use `client.subscribe` to subscribe the published stream to the receiver client.
5.  Use `client.getRemoteVideoStats` and `client.getRemoteAudioStats` to get the connection status of the Agora Web SDK.

```javascript
/**
 * Create two clients: a sender which will publish
 * a regular stream, and a receiver which will subscribe the
 * stream published by the sender.
 */
AgoraRTC.createMicrophoneAndCameraTracks(): Promise<[ILocalAudioTrack, ILocalVideoTrack]>
/** Get remote transfer information */
client.getRemoteVideoStats(): RemoteVideoTrackStatsMap
client.getRemoteAudioStats(): RemoteAudioTrackStatsMap
```

### Camera (optional)

Create a stream and play it, then let the users check if the video frame displays properly.

## References

See the `App.vue` file under **./src** for the complete code.

The following lists the major APIs used by this sample app:

- `AgoraRTC.createClient`
- `AgoraRTC.createMicrophoneAudioTrack`
- `AgoraRTC.createCameraVideoTrack`
- `AgoraRTC.createMicrophoneAndCameraTracks`
- `client.join`
- `client.publish`
- `client.subscribe`
- `client.getRemoteVideoStats`
- `client.getRemoteAudioStats`

For full details of the APIs, see the [Agora Web SDK NG API Reference](https://api-ref.agora.io/en/video-sdk/web/4.x/index.html).

## Licence

MIT
