import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates an RTM token for a user account.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';
  const userId = 'test_user_id';
  const expirationInSeconds = 3600;

  if (appId.isEmpty || appCertificate.isEmpty) {
    stderr.writeln(
      'Need to set environment variable AGORA_APP_ID and '
      'AGORA_APP_CERTIFICATE',
    );
    exitCode = 1;
    return;
  }

  final token = RtmTokenBuilder.buildToken(
    appId: appId,
    appCertificate: appCertificate,
    userId: userId,
    tokenExpireSeconds: expirationInSeconds,
  );
  _printToken('RTM token', token);
}

/// Prints a generated token and fails when generation returns an empty value.
void _printToken(String label, String token) {
  if (token.isEmpty) {
    throw StateError('$label generation failed');
  }
  stdout.writeln('$label: $token');
}
