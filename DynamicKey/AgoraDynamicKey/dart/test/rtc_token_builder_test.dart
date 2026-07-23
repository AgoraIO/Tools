import 'package:flutter_test/flutter_test.dart';
import 'package:agora_token_generator/agora_token_generator.dart';

/// Runs RTC Token Builder tests.
void main() {
  const String appId = '970CA35de60c44645bbae8a215061b33';
  const String appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const String channelName = '7d72365eb983485397e3e3f9d460bdda';
  const int uid = 2882341273;
  const String uidString = '2882341273';
  const int tokenExpireSeconds = 600;

  group('RTC Token Builder', () {
    // Verifies RTC Builder generation with a numeric user ID.
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
      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      expect(parsed.getServices(Service.RTC), hasLength(1));
    });

    // Verifies RTC Builder generation with a user account.
    test('buildTokenWithAccount returns a non-empty token', () {
      final token = RtcTokenBuilder.buildTokenWithAccount(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        account: uidString,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      expect(token, isNotEmpty);
      expect(token.startsWith('007'), isTrue);
      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final service = parsed.getServices(Service.RTC).single as ServiceRtc;
      expect(service.channelName, channelName);
      expect(service.uid, uidString);
    });

    // Verifies numeric user ID zero is encoded as a wildcard user ID.
    test('buildTokenWithUid supports wildcard uid', () {
      final token = RtcTokenBuilder.buildTokenWithUid(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        uid: 0,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service = parsed.getServices(Service.RTC).single as ServiceRtc;
      expect(service.uid, isEmpty);
    });
  });
}
