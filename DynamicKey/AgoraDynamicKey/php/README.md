# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `php` directory:

* `/src/` contains the source code for generating a token, where `RtcTokenBuilder.php` is used for generating an RTC token, and `RtmTokenBuilder.php` is used for generating an RTM token.
* `/sample/` contains the sample code for generating a token, where `RtcTokenBuilderSample.php` is used for generating an RTC token, and `RtmTokenBuilderSample.php` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `RtcTokenBuilderSample.cpp` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed the latest version of PHP.

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

2. Open the `DynamicKey/AgoraDynamicKey/php/sample/RtcTokenBuilderSample.php` file, replace the value of `appID`, `appCertificate`, `channelName`, and `uid` with your own, and comment out the code snippets of `buildTokenWithUserAccount`.

3. Open your Terminal, navigate to the same directory that holds `RtcTokenBuilderSample.php`, and run the following command. The token is generated and printed in your Terminal window.

   ```
   php RtcTokenBuilderSample.php
   ```


## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().