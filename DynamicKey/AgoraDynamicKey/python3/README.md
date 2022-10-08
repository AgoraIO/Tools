# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `python3` directory:

* `/src/` contains the source code for generating a token, where `RtcTokenBuilder.py` is used for generating an RTC token, and `RtmTokenBuilder.py` is used for generating an RTM token.
* `/sample/` contains the sample code for generating a token, where `RtcTokenBuilderSample.py` is used for generating an RTC token, and `RtmTokenBuilderSample.py` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `RtcTokenBuilderSample.py` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have Python 3 as the development environment. Use the following command to check your current Python version:

`Python -V`

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

2. Open the `DynamicKey/AgoraDynamicKey/python/sample/RtcTokenBuilderSample.py` file, replace the value of `appID`, `appCertificate`, `channelName`, and `uid` with your own, and comment out the code snippets of `buildTokenWithUserAccount`.

3. Open your Terminal, navigate to the same directory that holds `RtcTokenBuilderSample.py`, and run the following command. The token is generated and printed in your Terminal window:

   ```
   python RtcTokenBuilderSample.py
   ```


## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().

