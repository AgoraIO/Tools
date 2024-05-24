# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `rust`  directory:

* `/src/` contains the source code for generating a token, where `rtc_token_builder` is used for generating an RTC token, and `rtm_token_builder` is used for generating an RTM token.
* `/examples/` contains the sample code for generating a token, where `rtc_token_builder` is used for generating an RTC token, and `rtm_token_builder` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `rtc_token_builder` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed the latest version of Rust.

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

2. Open the `DynamicKey/AgoraDynamicKey/rust/examples/rtc_token_builder.rs` file, replace the value of `app_id`, `app_certificate`, `channel_name`, and `uid` with your own, and comment out the code snippets of `build_token_with_user_account`.

3. Open your Terminal, navigate to the same directory, and run the following command.

   ```
   cargo run --example rtc_token_builder
   ```

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().