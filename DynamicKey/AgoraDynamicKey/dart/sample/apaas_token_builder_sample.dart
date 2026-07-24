import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates APaaS room-user, user, and application Token007 tokens.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';
  const roomUuid = '123';
  const userUuid = '2882341273';
  const role = 1;
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
    'APaaS room-user token',
    ApaasTokenBuilder.buildRoomUserToken(
      appId: appId,
      appCertificate: appCertificate,
      roomUuid: roomUuid,
      userUuid: userUuid,
      role: role,
      expireSeconds: expireSeconds,
    ),
  );
  _printToken(
    'APaaS user token',
    ApaasTokenBuilder.buildUserToken(
      appId: appId,
      appCertificate: appCertificate,
      userUuid: userUuid,
      expireSeconds: expireSeconds,
    ),
  );
  _printToken(
    'APaaS app token',
    ApaasTokenBuilder.buildAppToken(
      appId: appId,
      appCertificate: appCertificate,
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
