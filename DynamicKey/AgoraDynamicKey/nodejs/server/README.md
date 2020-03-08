# How to use
## Fill in your vendor information
Open *DemoServer.js* and replace <YOUR APP ID> and <YOUR APP CERTIFICATE> with your value
```
// Fill the appID and appCertificate key given by Agora.io
var appID = "<YOUR APP ID>";
var appCertificate = "<YOUR APP CERTIFICATE>";
```

## Install Dependencies

```shell
npm i
node DemoServer.js
```

## Generate Token
### Generate RTC Token
```shell
curl http://localhost:8080/rtcToken?channelName=test
```

### Generate RTM Token
```shell
curl http://localhost:8080/rtmToken?account=testAccount
```
