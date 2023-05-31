# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Installation

This is a [Node.js](https://nodejs.org/en/) module available through the
[npm registry](https://www.npmjs.com/).

Before installing, [download and install Node.js](https://nodejs.org/en/download/).

Installation is done using the
[`npm install` command](https://docs.npmjs.com/getting-started/installing-npm-packages-locally):

```console
$ npm install agora-token
```

## Code structure

Under the `nodejs` directory:

* `/src/` contains the source code for generating a token, where `RtcTokenBuilder.js` is used for generating an RTC token, and `RtmTokenBuilder.js` is used for generating an RTM token.
* `/sample/` contains the sample code for generating a token, where `RtcTokenBuilderSample.js` is used for generating an RTC token, and `RtmTokenBuilderSample.js` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `RtcTokenBuilderSample.js` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed the LTS version of Node.js.

1. Run the following command to install the Node.js dependencies:

   ```
   npm install
   ```

2. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.

3. Open the `DynamicKey/AgoraDynamicKey/nodejs/sample/RtcTokenBuilderSample.js` file, replace the value of `appID`, `appCertificate`, `channelName`, and `uid` with your own, and comment out the code snippets of `buildTokenWithUserAccount`.

4. Open your Terminal, navigate to the same directory that holds `RtcTokenBuilderSample.js`, and run the following command. The token is generated and printed in your Terminal window.

   ```
   node RtcTokenBuilderSample.js
   ```

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().
