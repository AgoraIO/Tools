import 'dart:io';

import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  final appId = Platform.environment['AGORA_APP_ID'];
  final appCertificate = Platform.environment['AGORA_APP_CERTIFICATE'];

  const channelName = '7d72365eb983485397e3e3f9d460bdda';
  const rtcAccount = '2882341273';
  const rtcRole = RtcRole.publisher;
  const rtcTokenExpireSeconds = 3600;
  const joinChannelPrivilegeExpire = 3600;
  const publishAudioPrivilegeExpire = 3600;
  const publishVideoPrivilegeExpire = 3600;
  const publishDataPrivilegeExpire = 3600;
  const rtmUserId = '2882341273';
  const rtmTokenExpireSeconds = 3600;

  print('App Id: $appId');
  if (appId == null || appCertificate == null) {
    print('Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE');
    return;
  }

  final token = SttTokenBuilder.buildToken(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    rtcAccount: rtcAccount,
    rtcRole: rtcRole,
    rtcTokenExpireSeconds: rtcTokenExpireSeconds,
    joinChannelPrivilegeExpire: joinChannelPrivilegeExpire,
    publishAudioPrivilegeExpire: publishAudioPrivilegeExpire,
    publishVideoPrivilegeExpire: publishVideoPrivilegeExpire,
    publishDataPrivilegeExpire: publishDataPrivilegeExpire,
    rtmUserId: rtmUserId,
    rtmTokenExpireSeconds: rtmTokenExpireSeconds,
  );
  print('STT token: $token');
}
