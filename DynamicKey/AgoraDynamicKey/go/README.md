# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `go`  directory:

* `/src/` contains the source code for generating a token, where `RtcTokenBuilder` is used for generating an RTC token, and `RtmTokenBuilder` is used for generating an RTM token.
* `/sample/` contains the sample code for generating a token, where `RtcTokenBuilder` is used for generating an RTC token, and `RtmTokenBuilder` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `RtcTokenBuilder` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed the latest version of Golang.

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

2. Open the `DynamicKey/AgoraDynamicKey/go/sample/RtcTokenBuilder/sample.go` file, replace the value of `appID`, `appCertificate`, `channelName`, and `uid` with your own, and comment out the code snippets of `buildTokenWithUserAccount`.

3. Open your Terminal, navigate to the same directory that holds `sample.go`, and run the following command. After that, an executable file `RtcTokenBuilder` appears in the folder:

   ```
   go build
   ```

4. Run the following command. Your token is generated and printed in your Terminal window:

   ```
   ./RtcTokenBuilder
   ```

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().