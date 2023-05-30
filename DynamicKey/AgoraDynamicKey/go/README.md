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

## Deploying the Token Service Using Docker

Two Ways to quickly start the Token Service

### Option 1: Start the Service Using Docker Commands

Use the following Docker command to start the Token service:

```
docker run -d -it -p 8080:8080 -e APP_ID=[YOUR_APP_ID] -e APP_CERTIFICATE=[YOUR_APP_CERTIFICATE] --name agora-token-service agoracn/token:0.1.2023053011
```

> Replace `[YOUR_APP_ID]` and `[YOUR_APP_CERTIFICATE]` with your App ID and App Certificate.

After the service starts, you can use the following `curl` command to test it:

```
curl --location 'http://localhost:8080/token/generate' \
--header 'Content-Type: application/json' \
--data '{
    "channelName": "channel_name_test",
    "uid": "12345678",
    "tokenExpireTs": 3600,
    "privilegeExpireTs": 3600,
    "serviceRtc": {
        "enable": true,
        "role": 1
    },
    "serviceRtm": {
        "enable": true
    }
}'
```

> You can deploy the service on a virtual machine or [Alibaba Cloud ECS](https://www.aliyun.com/product/ecs), and after deployment, you need to replace `localhost` with your server's IP address.

For more information about the parameters, refer to [docker/server.go](docker/server.go).

### Option 2: Start the Service Using Docker Compose

In the `docker` directory, open the `docker-compose.yaml` file and set the `APP_ID` and `APP_CERTIFICATE` parameters. Then, use the following command to start the service:

```
docker-compose up
```

> You can modify the source code as needed. The source code can be found in [docker/server.go](docker/server.go).

## Reference

For a complete authentication flow between the app server and app client, see [Authenticate Your Users with Tokens]().