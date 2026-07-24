import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates Chat user and application Token007 tokens.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';
  const userUuid = 'a7180cb0-1d4a-11ed-9210-89ff47c9da5e';
  const expireSeconds = 600;

  if (appId.isEmpty || appCertificate.isEmpty) {
    stderr.writeln(
      'Need to set environment variable AGORA_APP_ID and '
      'AGORA_APP_CERTIFICATE',
    );
    exitCode = 1;
    return;
  }

  _printToken(
    'Chat app token',
    ChatTokenBuilder.buildChatAppToken(
      appId: appId,
      appCertificate: appCertificate,
      expireSeconds: expireSeconds,
    ),
  );
  _printToken(
    'Chat user token',
    ChatTokenBuilder.buildChatUserToken(
      appId: appId,
      appCertificate: appCertificate,
      userUuid: userUuid,
      expireSeconds: expireSeconds,
    ),
  );
}

/// Prints a generated token and fails when generation returns an empty value.
void _printToken(String label, String token) {
  if (token.isEmpty) {
    throw StateError('$label generation failed');
  }
  stdout.writeln('$label: $token');
}
