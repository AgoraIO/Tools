import 'package:flutter_test/flutter_test.dart';
import 'package:agora_token_generator/agora_token_generator.dart';

/// Runs RTM Token Builder tests.
void main() {
  const String appId = '970CA35de60c44645bbae8a215061b33';
  const String appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const String userId = 'test_user';
  const int tokenExpireSeconds = 900;

  group('RTM Token Builder', () {
    // Verifies RTM Builder generation and signature validation.
    test('buildToken returns a non-empty token', () {
      final token = RtmTokenBuilder.buildToken(
        appId: appId,
        appCertificate: appCertificate,
        userId: userId,
        tokenExpireSeconds: tokenExpireSeconds,
      );

      expect(token, isNotEmpty);
      expect(token.startsWith('007'), isTrue);
      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final service = parsed.getServices(Service.RTM).single as ServiceRtm;
      expect(service.userId, userId);
      expect(
        service.privileges[ServiceRtm.privilegeLogin],
        tokenExpireSeconds,
      );
    });
  });
}
