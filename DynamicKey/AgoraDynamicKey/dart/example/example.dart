import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  // Example values
  String appId = 'your-app-id';
  String appCertificate = 'your-app-certificate';
  String channelName = 'test-channel';
  int uid = 12345;
  String userAccount = 'test-user';
  int tokenExpireSeconds = 3600; // 1 hour

  // Generate RTC token with numeric UID
  String rtcToken = RtcTokenBuilder.buildTokenWithUid(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    uid: uid,
    tokenExpireSeconds: tokenExpireSeconds,
  );
  print('RTC Token with numeric UID: $rtcToken');

  // Generate RTC token with user account
  String rtcTokenWithAccount = RtcTokenBuilder.buildTokenWithAccount(
    appId: appId,
    appCertificate: appCertificate,
    channelName: channelName,
    account: userAccount,
    tokenExpireSeconds: tokenExpireSeconds,
  );
  print('RTC Token with user account: $rtcTokenWithAccount');

  // Generate RTM token
  String rtmToken = RtmTokenBuilder.buildToken(
    appId: appId,
    appCertificate: appCertificate,
    userId: userAccount,
    tokenExpireSeconds: tokenExpireSeconds,
  );
  print('RTM Token: $rtmToken');
}
