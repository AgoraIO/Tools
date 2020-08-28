# AgoraDynamicKey

This page describes the authentication mechanism used by the Agora SDK, as well as providing the related code for generating AccessToken (v2.1.0) or Dynamic Key (v2.0.2 or earlier).

**For users who want a quick deployable sample server to test with, please look at [here](https://github.com/AgoraIO-Community/TokenServer-nodejs)**

## AccessToken

AccessToken is more powerful than the legacy Dynamic Key. It encapsulates several privileges in one token to cover various services provided by Agora.

AccessToken is available as of SDK 2.1.0.

Sample usage,

```c++
AccessToken a(appID, appCertificate, channelName, uid);
a.AddPrivilege(AccessToken::kJoinChannel);
a.AddPrivilege(AccessToken::kPublishAudioStream);
std::string token = a.Build();
```
Sample Code for generating AccessToken are available on the following platforms:

 + C++
 + Go
 + Java
 + Node.js
 + Python
 + PHP
 + Perl
 + CSharp

> You can use either the following SimpleTokenBuilder or AccessToken sample code to generate an AccessToken. SimpleTokenBuilder encapsulates the underlying AccessToken sample code and is easy to use.

### C++

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/cpp/sample

### Go

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/go/sample

### Java

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/java

### Node.js

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/nodejs

### Python

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/python/sample

### PHP

+ https://github.com/AgoraIO/Tools/tree/master/DynamicKey/AgoraDynamicKey/php/sample

### Perl

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/perl/src/Agora/SimpleTokenBuilder.pm
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/perl/src/Agora/AccessToken.pm

### CSharp

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/csharp/src/AgoraIO/Media/AccessToken.cs

### **YOUR IMPLEMENTATIONS ARE VERY WELCOME.**

If you have implemented our algorithm in other languages, kindly file a pull request with us. We are delighted to merge any of the implementations that are correct and have test cases. Many thanks.


## Dynamic Key

The Dynamic Key is used by Agora SDKs of versions earlier than 2.1.

 + To join a media channel, use generateMediaChannelKey.
 + For recording services, use generateRecordingKey.

Following are samples for C++, Go, Java, Nodejs, PHP and Python.

### SDK and Dynamic Key Compatibility

If you are using the Agora SDK of a version earlier than 2.1 and looking at implementing the function of publishing with a permission key, Agora recommends that you upgrade to DynamicKey5.

#### To verify user permission in channel:
| Dynamic Key Version | UID | SDK Version  |
|---|---|---|
| DynamicKey5  | specify the permission | 1.7.0 or later  |


#### To verify the User ID:

| Dynamic Key Version | UID | SDK Version  |
|---|---|---|
| DynamicKey5  | specify uid of user | 1.3.0 or later  |
| DynamicKey4  | specify uid of user | 1.3.0 or later  |
| DynamicKey3  | specify uid of user  | 1.2.3 or later  |
| DynamicKey  |  NA |  NA |

#### If you do not need to verify the User ID:

| Dynamic Key Version | UID | SDK Version  |
|---|---|---|
| DynamicKey5  | 0 | All |
| DynamicKey4  | 0 | All |
| DynamicKey3  | 0 | All |
| DynamicKey  | All | All |

