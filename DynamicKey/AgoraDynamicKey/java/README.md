# Authenticate Users with a token

To enhance communication security, Agora uses tokens to authenticate users before they access the Agora service, or joining an RTC channel.

## Code structure

Under the `java` directory:

* `/src/main/java/io/agora/media/` contains the source code for generating an RTC token, where `RtcTokenBuilder.java` is used for generating an RTC token.
* `/src/main/java/io/agora/rtm/` contains the source code for generating an RTM token, where `RtmTokenBuilder.java` is used for generating an RTM token.
* `/src/main/java/io/agora/sample/` contains the sample code for generating a token, where `RtcTokenBuilderSample.java` is used for generating an RTC token, and `RtmTokenBuilderSample.java` is used for generating an RTM token.

## Generate a token with the sample code

This section takes `RtcTokenBuilderSample.java` as an example to show how to generate a token with the sample code.

Before proceeding, ensure that you have installed a Java IDE.

1. Download or clone the [Tools](https://github.com/AgoraIO/Tools) repository.
2. Open the `DynamicKey/AgoraDynamicKey/java` file in your IDE.
3. Open the `DynamicKey/AgoraDynamicKey/java/src/io/agora/sample/RtcTokenBuilder.java` file, replace the value of `appID`, `appCertificate`, `channelName`, and `uid` with your own, and comment out the code snippets of `buildTokenWithUserAccount`.
4. Run the sample project. Your token is generated and printed in your IDE.

## Maven Dependency

SDK can be obtained automatically via [Maven's dependency management](https://mvnrepository.com/artifact/io.agora/authentication) by adding the following configuration in the application's Project Object Model (POM) file:

    ```
    <dependency>
        <groupId>io.agora</groupId>
        <artifactId>authentication</artifactId>
        <version>${version}</version>
    </dependency>
    ```

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().

