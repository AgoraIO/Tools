import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs Chat Token007 Builder tests.
void main() {
  const appId = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const userUuid = '2882341273';
  const expireSeconds = 600;

  group('Chat Token Builder', () {
    // Verifies Chat user token fields, privilege, and signature.
    test('buildChatUserToken builds a user token', () {
      final token = ChatTokenBuilder.buildChatUserToken(
        appId: appId,
        appCertificate: appCertificate,
        userUuid: userUuid,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final service = parsed.getServices(Service.CHAT).single as ServiceChat;
      expect(service.userId, userUuid);
      expect(service.privileges[ServiceChat.privilegeUser], expireSeconds);
    });

    // Verifies Chat application token fields and privilege.
    test('buildChatAppToken builds an application token', () {
      final token = ChatTokenBuilder.buildChatAppToken(
        appId: appId,
        appCertificate: appCertificate,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final service = parsed.getServices(Service.CHAT).single as ServiceChat;
      expect(service.userId, isEmpty);
      expect(service.privileges[ServiceChat.privilegeApp], expireSeconds);
    });
  });
}
