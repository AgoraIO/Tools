import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

/// Generates a token containing RTC, RTM, and Chat services.
void main() {
  final appId = Platform.environment['AGORA_APP_ID'] ?? '';
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'] ?? '';
  const channelName = '7d72365eb983485397e3e3f9d460bdda';
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

  final rtcService = ServiceRtc(channelName, account)
    ..addPrivilege(
      ServiceRtc.privilegeJoinChannel,
      expirationInSeconds,
    );
  final rtmService = ServiceRtm(account)
    ..addPrivilege(ServiceRtm.privilegeLogin, expirationInSeconds);
  final chatService = ServiceChat(account)
    ..addPrivilege(ServiceChat.privilegeUser, expirationInSeconds);
  final token = AccessToken.create(
    appId,
    appCertificate,
    expire: expirationInSeconds,
  )
    ..addService(rtcService)
    ..addService(rtmService)
    ..addService(chatService);

  _printToken('The token for RTC, RTM and Chat is', token.build());
}

/// Prints a generated token and fails when generation returns an empty value.
void _printToken(String label, String token) {
  if (token.isEmpty) {
    throw StateError('$label generation failed');
  }
  stdout.writeln('$label: $token');
}
