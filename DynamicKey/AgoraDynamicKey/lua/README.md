# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `lua`  directory:

* `/src/` contains the source code for generating a token, where `rtc_token_builder` is used for generating an RTC token, and `rtm_token_builder` is used for generating an RTM token.
* `/sample/` contains the sample code for generating tokens, including a multi-service AccessToken2 token.

## Generate a token with the sample code

This section takes `rtc_token_builder` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed the latest version of Lua.

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

2. Set the `AGORA_APP_ID` and `AGORA_APP_CERTIFICATE` environment variables.

3. Open your Terminal, navigate to the same directory, and run the following command.

   ```
   luarocks make agora-token-0.1.0-1.rockspec
   lua sample/rtc_token_builder.lua
   ```

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().
