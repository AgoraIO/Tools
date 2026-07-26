# Agora Token Generator Kotlin

This project provides the Kotlin implementation of Agora AccessToken2 and Token007 builders.
It supports multiple services, duplicate service types, signature verification, Streaming,
FCDN, RTM2 resource permissions, and RTC, RTM, Chat, APaaS, Education, and FPA builders.

## Project Structure

- `src/main/kotlin`: Core logic for generating tokens.
- `src/sample/kotlin`: Sample usage of the token builders.
- `src/test/kotlin`: Unit tests for the implementation.

## How to use

### Build

You can build the project using Gradle:

```bash
./gradlew build
```

### Run Sample

To run the sample, you need to set the following environment variables:
- `AGORA_APP_ID`: Your Agora App ID.
- `AGORA_APP_CERTIFICATE`: Your Agora App Certificate.

Then run:

```bash
./gradlew runSample
```

### Run Tests

```bash
./gradlew test
```

## Example Usage

```kotlin
import io.agora.media.RtcTokenBuilder2

val appId = "YOUR_APP_ID"
val appCertificate = "YOUR_APP_CERTIFICATE"
val channelName = "YOUR_CHANNEL_NAME"
val uid = 123
val role = RtcTokenBuilder2.Role.ROLE_PUBLISHER
val tokenExpire = 3600
val privilegeExpire = 3600

val tokenBuilder = RtcTokenBuilder2()
val token = tokenBuilder.buildTokenWithUid(
    appId, appCertificate, channelName, uid, role,
    tokenExpire, privilegeExpire
)
println("Token: $token")
```
