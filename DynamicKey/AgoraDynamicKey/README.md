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

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/src/SimpleTokenBuilder.h
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/cpp/src/AccessToken.h

### Go

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/src/SimpleTokenBuilder/SimpleTokenBuilder.go
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/go/src/AccessToken/AccessToken.go

### Java

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/media/SimpleTokenBuilder.java
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/java/src/main/java/io/agora/media/AccessToken.java

### Node.js

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/nodejs/src/SimpleTokenBuilder.js
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/nodejs/src/AccessToken.js

### Python

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/src/SimpleTokenBuilder.py
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/python/src/AccessToken.py

### PHP

+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/src/SimpleTokenBuilder.php
+ https://github.com/AgoraIO/Tools/blob/master/DynamicKey/AgoraDynamicKey/php/src/AccessToken.php

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
