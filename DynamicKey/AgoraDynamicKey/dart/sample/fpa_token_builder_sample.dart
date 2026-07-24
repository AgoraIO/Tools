import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates an FPA login Token007 token.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';

  if (appId.isEmpty || appCertificate.isEmpty) {
    stderr.writeln(
      'Need to set environment variable AGORA_APP_ID and '
      'AGORA_APP_CERTIFICATE',
    );
    exitCode = 1;
    return;
  }

  final token = FpaTokenBuilder.buildToken(
    appId: appId,
    appCertificate: appCertificate,
  );
  if (token.isEmpty) {
    throw StateError('FPA token generation failed');
  }
  stdout.writeln('FPA token: $token');
}
