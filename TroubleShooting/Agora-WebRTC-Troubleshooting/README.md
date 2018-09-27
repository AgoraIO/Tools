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

Ensure you have an Agora developer account and an App ID before using this app, see [Agora Account](https://docs.agora.io/en/2.3.1/product/Voice/Quickstart%20Guide/web_prepare?platform=Web#creating-an-agora-account-and-getting-an-app-id) for details.

1.  Fill your App ID in the `settings.js` file under **./src/utils**.
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

1.  Use `AgoraRTC.createStream` to create an audio stream.
2.  Use `stream.getAudioLevel` to retrieve the current volume.

```javascript
/** create an audio stream and try to init/play it */
AgoraRTC.createStream(): stream
/**
 * accumulate audio level to check
 * if it is in an ideal range
 */
stream.getAudioLevel(): number
```

### Speaker

Use the audio element in HTML5 and let the users confirm whether they hear the sound.

### Resolution

1.  Use `AgoraRTC.createStream` to create video streams with different video profiles.
2.  Use `HTMLVideoElement` to get the video resolution.

```javascript
/** Create stream with different video profiles */
AgoraRTC.createStream(): stream
/** Get actual resolution from html element */
HTMLVideoElement.videoHeight
HTMLVideoElement.videoWidth
```

### Connection

1.  Use `AgoraRTC.createClient` to create a sender client and a receiver client.
2.  Use `AgoraRTC.createStream` to create a stream.
3.  Use `client.publish` to publish the stream from the sender client.
4.  Use `client.subscribe` to subscribe the published stream to the receiver client.
5.  Use `stream.getStats` to get the connection status of the Agora Web SDK.

```javascript
/**
 * Create two clients: a sender which will publish
 * a regular stream, and a receiver which will subscribe the
 * stream published by the sender.
 */
AgoraRTC.createStream(): stream
/** Get stream tranfer info by using getStats */
stream.getStats(callback: (stats:any) => void): void
```

### Camera (optional)

Create a stream and play it, then let the users check if the video frame displays properly.

## References

See the `App.vue` file under **./src** for the complete code.

The following lists the major APIs used by this sample app:

- [AgoraRTC.createClient](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#agorartc-createclient)
- [client.init](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#client-ini)
- [client.join](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#client-join)
- [AgoraRTC.createStream](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#agorartc-createstream)
- [stream.init](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#stream-init)
- [stream.setVideoProfile](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#set-the-video-profile-setvideoprofile)
- [client.publish](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#client-publish)
- [client.subscribe](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#client-subscribe)
- [stream.play](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#stream-play)
- [stream.getStats](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video#stream-getstats)

For full details of the APIs, see [Agora Web API Reference](https://docs.agora.io/en/2.3.1/product/Video/API%20Reference/communication_web_video?platform=Web).

## Licence

MIT
