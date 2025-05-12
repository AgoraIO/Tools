# Agora Token Generator

A Flutter package for generating Agora Dynamic Keys and Access Tokens to use with Agora.io SDKs. This package provides a pure Dart implementation of Agora's token generation mechanism.

## Features

- Generate RTC tokens for Agora Real-Time Communications
- Generate RTM tokens for Agora Real-Time Messaging
- Support for the latest token format (AccessToken2 - 007)
- No native dependencies

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  agora_token_generator: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### RTC Token

Generate a token for Agora RTC service with a numeric user ID:

```dart
import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  String appId = 'YOUR_APP_ID';
  String appCertificate = 'YOUR_APP_CERTIFICATE';
  String channelName = 'test_channel';
  int uid = 12345;
  int tokenExpireSeconds = 3600; // Token expires in 1 hour

  String token = RtcTokenBuilder.buildTokenWithUid(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    uid: uid,
    tokenExpireSeconds: tokenExpireSeconds,
  );

  print('RTC Token: $token');
}
```

Generate a token for Agora RTC service with a string user account:

```dart
import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  String appId = 'YOUR_APP_ID';
  String appCertificate = 'YOUR_APP_CERTIFICATE';
  String channelName = 'test_channel';
  String userAccount = 'user123';
  int tokenExpireSeconds = 3600; // Token expires in 1 hour

  String token = RtcTokenBuilder.buildTokenWithAccount(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    account: userAccount,
    tokenExpireSeconds: tokenExpireSeconds,
  );

  print('RTC Token with User Account: $token');
}
```

### RTM Token

Generate a token for Agora RTM service:

```dart
import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  String appId = 'YOUR_APP_ID';
  String appCertificate = 'YOUR_APP_CERTIFICATE';
  String userId = 'user123';
  int tokenExpireSeconds = 3600; // Token expires in 1 hour

  String token = RtmTokenBuilder.buildToken(
    appId: appId,
    appCertificate: appCertificate,
    userId: userId,
    tokenExpireSeconds: tokenExpireSeconds,
  );

  print('RTM Token: $token');
}
```

## Getting Agora App ID and App Certificate

To use this token generator, you need to get an App ID and App Certificate from Agora:

1. Create an account at [https://console.agora.io/](https://console.agora.io/)
2. Create a new project
3. Get the App ID from the project dashboard
4. Generate an App Certificate for your project (Keep it safe and don't share it!)

## About Agora Token Authentication

Agora uses token-based authentication to secure connections to their services. This package implements the latest token format (AccessToken2 - 007).

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

This Flutter/Dart implementation is based on Agora's official authentication mechanism as demonstrated in their SDKs for other languages.
