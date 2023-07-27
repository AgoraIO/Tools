# AgoraDynamicKey

This page describes the authentication mechanism used by the Agora SDK, as well as providing the related code for generating AccessToken (v2.1.0) or Dynamic Key (v2.0.2 or earlier).

**For users who want a quick deployable sample server to test with, please look at [here](https://github.com/AgoraIO-Community/TokenServer-nodejs)**

> **Agora recommend using AccessToken2(version 007)**

Refer to [Secure authentication with tokens
](https://docs.agora.io/en/signaling/develop/authentication-workflow?platform=android)

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
 + Python3
 + PHP
 + Perl
 + CSharp
 + Ruby

> You can use RTC/RTM sample code to generate an AccessToken. 

### C++

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/sample/RtcTokenBuilder2Sample.cpp
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/sample/RtmTokenBuilder2Sample.cpp
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/sample/RtcTokenBuilderSample.cpp
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/sample/RtmTokenBuilderSample.cpp

### Go

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/sample/rtctokenbuilder2/sample.go
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/sample/rtmtokenbuilder2/sample.go
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/sample/RtcTokenBuilder/sample.go
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/sample/RtmTokenBuilder/sample.go

### Java

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/sample/RtcTokenBuilder2Sample.java
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/sample/RtmTokenBuilder2Sample.java
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/sample/RtcTokenBuilderSample.java
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/sample/RtmTokenBuilderSample.java

### Node.js

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/nodejs/sample/RtcTokenBuilder2Sample.js
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/nodejs/sample/RtcTokenBuilderSample.js
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/nodejs/sample/RtmTokenBuilderSample.js

### Python

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/sample/RtcTokenBuilder2Sample.py
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/sample/RtmTokenBuilder2Sample.py
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/sample/RtcTokenBuilderSample.py
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/sample/RtmTokenBuilderSample.py

### Python3

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python3/sample/RtcTokenBuilder2Sample.py
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python3/sample/RtmTokenBuilder2Sample.py
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python3/sample/RtcTokenBuilderSample.py
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python3/sample/RtmTokenBuilderSample.py

### PHP

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/sample/RtcTokenBuilder2Sample.php
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/sample/RtmTokenBuilder2Sample.php
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/sample/RtcTokenBuilderSample.php
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/sample/RtmTokenBuilderSample.php

### Perl

- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/perl/sample/sample_access_token.pl
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/perl/sample/sample_simple_token_builder.pl

### CSharp

- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/csharp/sample/RtcTokenBuilderSample.cs
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/csharp/sample/RtmTokenBuilderSample.cs

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/csharp/sample/AccessToken2BuilderSample.cs

### Ruby

- Version 007
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/ruby/sample/rtc_token_builder2_sample.rb
- Version 006
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/ruby/sample/rtc_token_builder_sample.rb
  + https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/ruby/sample/rtm_token_builder_sample.rb

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



### C++
```c
/**
 * build with command:
 * g++ main.cpp  -lcrypto -std=c++0x
 */
#include "../src/DynamicKey5.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {
  ::srand(::time(NULL));

  auto appID  = "970ca35de60c44645bbae8a215061b33";
  auto  appCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
  auto channelName= "my channel name for recording";
  auto  unixTs = ::time(NULL);
  int randomInt = (::rand()%256 << 24) + (::rand()%256 << 16) + (::rand()%256 << 8) + (::rand()%256);
  uint32_t uid = 2882341273u;
  auto  expiredTs = 0;

  std::cout << std::endl;
  std::cout << DynamicKey5::generateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) << std::endl;
  return 0;
}

```

### Go
```go
package main

import (
    "../src/DynamicKey5"
    "fmt"
)

func main() {
    appID:="970ca35de60c44645bbae8a215061b33"
    appCertificate:="5cfd2fd1755d40ecb72977518be15d3b"
    channelName := "7d72365eb983485397e3e3f9d460bdda"
    unixTs:=uint32(1446455472)
    uid:=uint32(2882341273)
    randomInt:=uint32(58964981)
    expiredTs:=uint32(1446455471)

    var mediaChannelKey,channelError = DynamicKey5.GenerateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs)
    if channelError == nil {
        fmt.Println(mediaChannelKey)
    }

}
```

### Java
```java
package io.agora.media.sample;

import io.agora.media.DynamicKey5;

import java.util.Date;
import java.util.Random;

public class DynamicKey5Sample {
    static String appID = "970ca35de60c44645bbae8a215061b33";
    static String appCertificate = "5cfd2fd1755d40ecb72977518be15d3b";
    static String channel = "7d72365eb983485397e3e3f9d460bdda";
    static int ts = (int)(new Date().getTime()/1000);
    static int r = new Random().nextInt();
    static long uid = 2882341273L;
    static int expiredTs = 0;

    public static void main(String[] args) throws Exception {
        System.out.println(DynamicKey5.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
    }
}
```

### Node.js
```javascript
var DynamicKey5 = require('../src/DynamicKey5');
var appID  = "970ca35de60c44645bbae8a215061b33";
var appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b";
var channel = "my channel name";
var ts = Math.floor(new Date() / 1000);
var r = Math.floor(Math.random() * 0xFFFFFFFF);
var uid = 2882341273;
var expiredTs = 0;

console.log("5 channel key: " + DynamicKey5.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
```

### PHP
```php
<?php
include "../src/DynamicKey5.php";

$appID = '970ca35de60c44645bbae8a215061b33';
$appCertificate = '5cfd2fd1755d40ecb72977518be15d3b';
$channelName = "7d72365eb983485397e3e3f9d460bdda";
$ts = 1446455472;
$randomInt = 58964981;
$uid = 2882341273;
$expiredTs = 1446455471;

echo generateMediaChannelKey($appID, $appCertificate, $channelName, $ts, $randomInt, $uid, $expiredTs) . "\n";
?>

```

### Python
```python
import sys
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from DynamicKey5 import *

appID   = "970ca35de60c44645bbae8a215061b33"
appCertificate     = "5cfd2fd1755d40ecb72977518be15d3b"
channelname = "7d72365eb983485397e3e3f9d460bdda"
unixts = int(time.time());
uid = 2882341273
randomint = -2147483647
expiredts = 0

print "%.8x" % (randomint & 0xFFFFFFFF)

if __name__ == "__main__":
    print generateMediaChannelKey(appID, appCertificate, channelname, unixts, randomint, uid, expiredts)

```

### Ruby
```ruby
require '../src/dynamic_key5'
app_id = "970ca35de60c44645bbae8a215061b33"
app_certificate = "5cfd2fd1755d40ecb72977518be15d3b"
channel_name = "7d72365eb983485397e3e3f9d460bdda"
unix_ts = Time.now.utc.to_i
uid = 2882341273
random_int = -2147483647
expired_ts = 0

puts "%.8x" % (random_int & 0xFFFFFFFF)

media_channel_key = DynamicKey5.gen_media_channel_key(app_id, app_certificate, channel_name, unix_ts, random_int, uid, expired_ts)

puts "media_channel_key:#{media_channel_key}"


```
### Perl
```perl
use Agora::DynamicKey5;

my $app_id          = "970ca35de60c44645bbae8a215061b33";
my $app_certificate = "5cfd2fd1755d40ecb72977518be15d3b";
my $channel_name    = "7d72365eb983485397e3e3f9d460bdda";
my $unix_ts         = time();
my $uid             = 2882341273;
my $random_int      = -2147483647;
my $expired_ts      = 0;

my $media_channel_key = Agora::DynamicKey5::gen_media_channel_key($app_id, $app_certificate, $channel_name, $unix_ts, $random_int, $uid, $expired_ts);

say "media_channel_key:$media_channel_key";
```

## Tool 
### Parse token

```
Usage
# python3 parse.py YOUR_TOKEN
OR
# make parse token=YOUR_TOKEN

Test token with web page
- For RTC, https://webdemo.agora.io/agora-web-showcase/examples/Agora-Web-Tutorial-1to1-Web/
- For RTM, https://webdemo.agora.io/agora-web-showcase/examples/Agora-RTM-Tutorial-Web/
```

## Deploying the Token Service Using Docker
Please refer to the [go/README.md](go/README.md#deploying-the-token-service-using-docker) file located in the "go" directory for instructions on how to deploy the Token Service using Docker.

## License

The sample projects are under the MIT license.
