# How to use
## Install

```shell
npm i agora-access-token
```

## Import
```javascript
const {AccessToken} = require('./index')
const {Token, Priviledges} = AccessToken
```

### Generate
```javascript
var appID = "<Your app ID>";
var appCertificate = "<Your app certificate>";
var channel = "<The channel this token is generated for>";
var uid = <The uid this token is generated for>;

// expire timestamp, 0 indicates never expire - note a key is valid for 24 hours maximum
var expireTimestamp = 0;

var key = new Token(appID, appCertificate, channel, uid);
key.addPriviledge(Priviledges.kJoinChannel, expireTimestamp);

var token = key.build();
```
