import 'package:flutter_test/flutter_test.dart';
import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  const String appId = 'test-app-id';
  const String appCertificate = 'test-app-certificate';
  const String channelName = 'test-channel';
  const int uid = 12345;
  const String userId = 'test-user';
  const int tokenExpireSeconds = 3600;

  group('RTC Token Builder', () {
    test('buildTokenWithUid returns a non-empty token', () {
      final token = RtcTokenBuilder.buildTokenWithUid(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        uid: uid,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      expect(token, isNotEmpty);
      expect(token.startsWith('007'), isTrue);
    });

    test('buildTokenWithAccount returns a non-empty token', () {
      final token = RtcTokenBuilder.buildTokenWithAccount(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        account: userId,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      expect(token, isNotEmpty);
      expect(token.startsWith('007'), isTrue);
    });
  });

  group('RTM Token Builder', () {
    test('buildToken returns a non-empty token', () {
      final token = RtmTokenBuilder.buildToken(
        appId: appId,
        appCertificate: appCertificate,
        userId: userId,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      expect(token, isNotEmpty);
      expect(token.startsWith('007'), isTrue);
    });
  });
}
