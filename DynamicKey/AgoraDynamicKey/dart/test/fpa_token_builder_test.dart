import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs FPA Token007 Builder tests.
void main() {
  const appId = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';

  group('FPA Token Builder', () {
    // Verifies the fixed token expiration and FPA login privilege.
    test('buildToken builds an FPA login token', () {
      final token = FpaTokenBuilder.buildToken(
        appId: appId,
        appCertificate: appCertificate,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      expect(parsed.expire, 24 * 60 * 60);
      final service = parsed.getServices(Service.FPA).single as ServiceFpa;
      expect(service.privileges[ServiceFpa.privilegeLogin], 0);
    });
  });
}
