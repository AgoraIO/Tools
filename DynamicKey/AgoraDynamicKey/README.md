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
#include <iostream>
#include <cstdlib>

#include "../src/RtcTokenBuilder2.h"

using namespace agora::tools;

int main(int argc, char const *argv[])
{
    (void)argc;
    (void)argv;

    // Need to set environment variable AGORA_APP_ID
    const char *env_app_id = getenv("AGORA_APP_ID");
    std::string app_id = env_app_id ? env_app_id : "";
    // Need to set environment variable AGORA_APP_CERTIFICATE
    const char *env_app_certificate = getenv("AGORA_APP_CERTIFICATE");
    std::string app_certificate = env_app_certificate ? env_app_certificate : "";

    std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";
    uint32_t uid = 2882341273;
    std::string account = "2882341273";
    uint32_t token_expiration_in_seconds = 3600;
    uint32_t privilege_expiration_in_seconds = 3600;
    uint32_t join_channel_privilege_expiration_in_seconds = 3600;
    uint32_t pub_audio_privilege_expiration_in_seconds = 3600;
    uint32_t pub_video_privilege_expiration_in_seconds = 3600;
    uint32_t pub_data_stream_privilege_expiration_in_seconds = 3600;
    std::string result;

    std::cout << "App Id:" << app_id << std::endl;
    std::cout << "App Certificate:" << app_certificate << std::endl;
    if (app_id == "" || app_certificate == "")
    {
        std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
        return -1;
    }

    result = RtcTokenBuilder2::BuildTokenWithUid(
        app_id, app_certificate, channel_name, uid, UserRole::kRolePublisher,
        token_expiration_in_seconds, privilege_expiration_in_seconds);
    std::cout << "Token With Int Uid:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUserAccount(
        app_id, app_certificate, channel_name, account, UserRole::kRolePublisher,
        token_expiration_in_seconds, privilege_expiration_in_seconds);
    std::cout << "Token With UserAccount:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUid(
        app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
        pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
    std::cout << "Token With Int Uid:" << result << std::endl;

    result = RtcTokenBuilder2::BuildTokenWithUserAccount(
        app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
        pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
    std::cout << "Token With UserAccount:" << result << std::endl;

    return 0;
}
```

### Go
```go
package main

import (
	"fmt"
	"os"

	rtctokenbuilder "github.com/AgoraIO/Tools/DynamicKey/AgoraDynamicKey/go/src/rtctokenbuilder2"
)

func main() {
	// Need to set environment variable AGORA_APP_ID
	appId := os.Getenv("AGORA_APP_ID")
	// Need to set environment variable AGORA_APP_CERTIFICATE
	appCertificate := os.Getenv("AGORA_APP_CERTIFICATE")

	channelName := "7d72365eb983485397e3e3f9d460bdda"
	uid := uint32(2882341273)
	uidStr := "2882341273"
	tokenExpirationInSeconds := uint32(3600)
	privilegeExpirationInSeconds := uint32(3600)
	joinChannelPrivilegeExpireInSeconds := uint32(3600)
	pubAudioPrivilegeExpireInSeconds := uint32(3600)
	pubVideoPrivilegeExpireInSeconds := uint32(3600)
	pubDataStreamPrivilegeExpireInSeconds := uint32(3600)

	fmt.Println("App Id:", appId)
	fmt.Println("App Certificate:", appCertificate)
	if appId == "" || appCertificate == "" {
		fmt.Println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
		return
	}

	result, err := rtctokenbuilder.BuildTokenWithUid(appId, appCertificate, channelName, uid, rtctokenbuilder.RoleSubscriber, tokenExpirationInSeconds, privilegeExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with int uid: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUserAccount(appId, appCertificate, channelName, uidStr, rtctokenbuilder.RoleSubscriber, tokenExpirationInSeconds, privilegeExpirationInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with user account: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUidAndPrivilege(appId, appCertificate, channelName, uid,
		tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with int uid and privilege: %s\n", result)
	}

	result, err = rtctokenbuilder.BuildTokenWithUserAccountAndPrivilege(appId, appCertificate, channelName, uidStr,
		tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds)
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Printf("Token with user account and privilege: %s\n", result)
	}
}
```

### Java
```java
package io.agora.sample;

import io.agora.media.RtcTokenBuilder2;
import io.agora.media.RtcTokenBuilder2.Role;

public class RtcTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    static String channelName = "7d72365eb983485397e3e3f9d460bdda";
    static String account = "2082341273";
    static int uid = 2082341273;
    static int tokenExpirationInSeconds = 3600;
    static int privilegeExpirationInSeconds = 3600;
    static int joinChannelPrivilegeExpireInSeconds = 3600;
    static int pubAudioPrivilegeExpireInSeconds = 3600;
    static int pubVideoPrivilegeExpireInSeconds = 3600;
    static int pubDataStreamPrivilegeExpireInSeconds = 3600;

    public static void main(String[] args) {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        RtcTokenBuilder2 token = new RtcTokenBuilder2();
        String result = token.buildTokenWithUid(appId, appCertificate, channelName, uid, Role.ROLE_SUBSCRIBER,
                tokenExpirationInSeconds, privilegeExpirationInSeconds);
        System.out.printf("Token with uid: %s\n", result);

        result = token.buildTokenWithUserAccount(appId, appCertificate, channelName, account,
                Role.ROLE_SUBSCRIBER,
                tokenExpirationInSeconds, privilegeExpirationInSeconds);
        System.out.printf("Token with account: %s\n", result);

        result = token.buildTokenWithUid(appId, appCertificate, channelName, uid, tokenExpirationInSeconds,
                joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds,
                pubVideoPrivilegeExpireInSeconds,
                pubDataStreamPrivilegeExpireInSeconds);
        System.out.printf("Token with uid and privilege: %s\n", result);

        result = token.buildTokenWithUserAccount(appId, appCertificate, channelName, account,
                tokenExpirationInSeconds,
                joinChannelPrivilegeExpireInSeconds, pubAudioPrivilegeExpireInSeconds,
                pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds);
        System.out.printf("Token with account and privilege: %s\n", result);
    }
}
```

### Node.js
```javascript
const RtcTokenBuilder = require("../src/RtcTokenBuilder2").RtcTokenBuilder;
const RtcRole = require("../src/RtcTokenBuilder2").Role;

// Need to set environment variable AGORA_APP_ID
const appID = process.env.AGORA_APP_ID;
// Need to set environment variable AGORA_APP_CERTIFICATE
const appCertificate = process.env.AGORA_APP_CERTIFICATE;

const channelName = "7d72365eb983485397e3e3f9d460bdda";
const uid = 2882341273;
const account = "2882341273";
const role = RtcRole.PUBLISHER;
const tokenExpirationInSecond = 3600;
const privilegeExpirationInSecond = 3600;
const joinChannelPrivilegeExpireInSeconds = 3600;
const pubAudioPrivilegeExpireInSeconds = 3600;
const pubVideoPrivilegeExpireInSeconds = 3600;
const pubDataStreamPrivilegeExpireInSeconds = 3600;

// Build token with uid
const tokenA = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, tokenExpirationInSecond, privilegeExpirationInSecond);
console.log("Token with int uid: " + tokenA);

// Build token with user account
const tokenB = RtcTokenBuilder.buildTokenWithUserAccount(
    appID,
    appCertificate,
    channelName,
    account,
    role,
    tokenExpirationInSecond,
    privilegeExpirationInSecond
);
console.log("Token with user account: " + tokenB);

const tokenC = RtcTokenBuilder.buildTokenWithUidAndPrivilege(
    appID,
    appCertificate,
    channelName,
    uid,
    tokenExpirationInSecond,
    joinChannelPrivilegeExpireInSeconds,
    pubAudioPrivilegeExpireInSeconds,
    pubVideoPrivilegeExpireInSeconds,
    pubDataStreamPrivilegeExpireInSeconds
);
console.log("Token with int uid and privilege:" + tokenC);

const tokenD = RtcTokenBuilder.BuildTokenWithUserAccountAndPrivilege(
    appID,
    appCertificate,
    channelName,
    account,
    tokenExpirationInSecond,
    joinChannelPrivilegeExpireInSeconds,
    pubAudioPrivilegeExpireInSeconds,
    pubVideoPrivilegeExpireInSeconds,
    pubDataStreamPrivilegeExpireInSeconds
);
console.log("Token with user account and privilege:" + tokenD);
```

### PHP
```php
<?php
include("../src/RtcTokenBuilder2.php");

// Need to set environment variable AGORA_APP_ID
$appId = getenv("AGORA_APP_ID");
// Need to set environment variable AGORA_APP_CERTIFICATE
$appCertificate = getenv("AGORA_APP_CERTIFICATE");

$channelName = "7d72365eb983485397e3e3f9d460bdda";
$uid = 2882341273;
$uidStr = "2882341273";
$tokenExpirationInSeconds = 3600;
$privilegeExpirationInSeconds = 3600;
$joinChannelPrivilegeExpireInSeconds = 3600;
$pubAudioPrivilegeExpireInSeconds = 3600;
$pubVideoPrivilegeExpireInSeconds = 3600;
$pubDataStreamPrivilegeExpireInSeconds = 3600;

$token = RtcTokenBuilder2::buildTokenWithUid($appId, $appCertificate, $channelName, $uid, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with int uid: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccount($appId, $appCertificate, $channelName, $uidStr, RtcTokenBuilder2::ROLE_PUBLISHER, $tokenExpirationInSeconds, $privilegeExpirationInSeconds);
echo 'Token with user account: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUidAndPrivilege($appId, $appCertificate, $channelName, $uid, $tokenExpirationInSeconds, $joinChannelPrivilegeExpireInSeconds, $pubAudioPrivilegeExpireInSeconds, $pubVideoPrivilegeExpireInSeconds, $pubDataStreamPrivilegeExpireInSeconds);
echo 'Token with int uid and privilege: ' . $token . PHP_EOL;

$token = RtcTokenBuilder2::buildTokenWithUserAccountAndPrivilege($appId, $appCertificate, $channelName, $uidStr, $tokenExpirationInSeconds, $joinChannelPrivilegeExpireInSeconds, $pubAudioPrivilegeExpireInSeconds, $pubVideoPrivilegeExpireInSeconds, $pubDataStreamPrivilegeExpireInSeconds);
echo 'Token with user account and privilege: ' . $token . PHP_EOL;
```

### Python
```python
# ! -*- coding: utf-8 -*-

import sys
import unittest
import os
import time
from random import randint

sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))
from RtcTokenBuilder import *
import AccessToken

# Need to set environment variable AGORA_APP_ID
appID = os.environ.get("AGORA_APP_ID")
# Need to set environment variable AGORA_APP_CERTIFICATE
appCertificate = os.environ.get("AGORA_APP_CERTIFICATE")

channelName = "7d72365eb983485397e3e3f9d460bdda"
uid = 2882341273
userAccount = "2882341273"
expireTimeInSeconds = 3600
currentTimestamp = int(time.time())
privilegeExpiredTs = currentTimestamp + expireTimeInSeconds


def main():
    token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, Role_Attendee, privilegeExpiredTs)
    print("Token with int uid: {}".format(token))
    token = RtcTokenBuilder.buildTokenWithAccount(appID, appCertificate, channelName, userAccount, Role_Attendee, privilegeExpiredTs)
    print("Token with user account: {}".format(token))

if __name__ == "__main__":
    main()
```

### Python3
```python
# -*- coding: utf-8 -*-

import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from src.RtcTokenBuilder2 import *


def main():
    # Need to set environment variable AGORA_APP_ID
    app_id = os.environ.get("AGORA_APP_ID")
    # Need to set environment variable AGORA_APP_CERTIFICATE
    app_certificate = os.environ.get("AGORA_APP_CERTIFICATE")

    channel_name = "7d72365eb983485397e3e3f9d460bdda"
    uid = 2882341273
    account = "2882341273"
    token_expiration_in_seconds = 3600
    privilege_expiration_in_seconds = 3600
    join_channel_privilege_expiration_in_seconds = 3600
    pub_audio_privilege_expiration_in_seconds = 3600
    pub_video_privilege_expiration_in_seconds = 3600
    pub_data_stream_privilege_expiration_in_seconds = 3600

    token = RtcTokenBuilder.build_token_with_uid(app_id, app_certificate, channel_name, uid, Role_Subscriber,
                                                 token_expiration_in_seconds, privilege_expiration_in_seconds)
    print("Token with int uid: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account(app_id, app_certificate, channel_name, account,
                                                          Role_Subscriber, token_expiration_in_seconds,
                                                          privilege_expiration_in_seconds)
    print("Token with user account: {}".format(token))

    token = RtcTokenBuilder.build_token_with_uid_and_privilege(
        app_id, app_certificate, channel_name, uid, token_expiration_in_seconds, 
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with int uid and privilege: {}".format(token))

    token = RtcTokenBuilder.build_token_with_user_account_and_privilege(
        app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
        join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds, pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds)
    print("Token with user account and privilege: {}".format(token))


if __name__ == "__main__":
    main()
```

### Ruby
```ruby
require_relative '../lib/dynamic_key2'

# Need to set environment variable AGORA_APP_ID
app_id = ENV['AGORA_APP_ID']
# Need to set environment variable AGORA_APP_CERTIFICATE
app_certificate = ENV['AGORA_APP_CERTIFICATE']

channel_name = '7d72365eb983485397e3e3f9d460bdda'
uid = 2_882_341_273
account = '2882341273'
token_expiration_in_seconds = 3600
privilege_expiration_in_seconds = 3600
join_channel_privilege_expiration_in_seconds = 3600
pub_audio_privilege_expiration_in_seconds = 3600
pub_video_privilege_expiration_in_seconds = 3600
pub_data_stream_privilege_expiration_in_seconds = 3600

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid(
  app_id, app_certificate, channel_name, uid,
  AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, token_expiration_in_seconds, privilege_expiration_in_seconds
)
puts "Token with int uid: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account(
  app_id, app_certificate, channel_name, account,
  AgoraDynamicKey2::RtcTokenBuilder::ROLE_SUBSCRIBER, token_expiration_in_seconds, privilege_expiration_in_seconds
)
puts "Token with user account: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_uid_and_privilege(
  app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
  join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
  pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds
)
puts "Token with int uid and privilege: #{token}"

token = AgoraDynamicKey2::RtcTokenBuilder.build_token_with_user_account_and_privilege(
  app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
  join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
  pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds
)
puts "Token with user account and privilege: #{token}"
```

### Perl
```perl
#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use 5.010;

use FindBin;

use lib $FindBin::Bin."/../src";

use Agora::AccessToken;

# Need to set environment variable AGORA_APP_ID
my $app_id           = $ENV{AGORA_APP_ID};
# Need to set environment variable AGORA_APP_CERTIFICATE
my $app_certificate  = $ENV{AGORA_APP_CERTIFICATE};

my $channel_name     = "7d72365eb983485397e3e3f9d460bdda";
my $uid              = 2882341273;
my $expire_timestamp = 0;

my $token = Agora::AccessToken::create_access_token($app_id, $app_certificate, $channel_name, $uid);
$token->add_privilege(Agora::AccessToken::KJoinChannel, $expire_timestamp);

my $token_str = $token->build;
say "access_token\t$token_str";
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
