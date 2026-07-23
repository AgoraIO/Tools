import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates RTC tokens with a numeric UID and a user account.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';
  const channelName = '7d72365eb983485397e3e3f9d460bdda';
  const uid = 2882341273;
  const account = '2882341273';
  const expirationInSeconds = 3600;

  if (appId.isEmpty || appCertificate.isEmpty) {
    stderr.writeln(
      'Need to set environment variable AGORA_APP_ID and '
      'AGORA_APP_CERTIFICATE',
    );
    exitCode = 1;
    return;
  }

  final tokenWithUid = RtcTokenBuilder.buildTokenWithUid(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    uid: uid,
    tokenExpireSeconds: expirationInSeconds,
  );
  _printToken('Token with int uid', tokenWithUid);

  final tokenWithUserAccount = RtcTokenBuilder.buildTokenWithAccount(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    account: account,
    tokenExpireSeconds: expirationInSeconds,
  );
  _printToken('Token with user account', tokenWithUserAccount);
}

/// Prints a generated token and fails when generation returns an empty value.
void _printToken(String label, String token) {
  if (token.isEmpty) {
    throw StateError('$label generation failed');
  }
  stdout.writeln('$label: $token');
}
