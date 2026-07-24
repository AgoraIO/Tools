import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs APaaS Token007 Builder tests.
void main() {
  const appId = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const roomUuid = '123';
  const userUuid = '2882341273';
  const role = 1;
  const expireSeconds = 600;

  group('APaaS Token Builder', () {
    // Verifies room-user tokens contain APaaS, RTM, and Chat services.
    test('buildRoomUserToken builds all required services', () {
      final token = ApaasTokenBuilder.buildRoomUserToken(
        appId: appId,
        appCertificate: appCertificate,
        roomUuid: roomUuid,
        userUuid: userUuid,
        role: role,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      expect(parsed.services.map((service) => service.serviceType), [
        Service.RTM,
        Service.CHAT,
        Service.APAAS,
      ]);
      final apaas = parsed.getServices(Service.APAAS).single as ServiceApaas;
      final rtm = parsed.getServices(Service.RTM).single as ServiceRtm;
      final chat = parsed.getServices(Service.CHAT).single as ServiceChat;
      expect(apaas.roomUuid, roomUuid);
      expect(apaas.userUuid, userUuid);
      expect(apaas.role, role);
      expect(
        apaas.privileges[ServiceApaas.privilegeRoomUser],
        expireSeconds,
      );
      expect(rtm.userId, userUuid);
      expect(chat.userId, '6063383428a36fba3fb6030becf8094e');
    });

    // Verifies APaaS user token fields and privilege.
    test('buildUserToken builds a user token', () {
      final token = ApaasTokenBuilder.buildUserToken(
        appId: appId,
        appCertificate: appCertificate,
        userUuid: userUuid,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service = parsed.getServices(Service.APAAS).single as ServiceApaas;
      expect(service.roomUuid, isEmpty);
      expect(service.userUuid, userUuid);
      expect(service.role, -1);
      expect(service.privileges[ServiceApaas.privilegeUser], expireSeconds);
    });

    // Verifies APaaS application token fields and privilege.
    test('buildAppToken builds an application token', () {
      final token = ApaasTokenBuilder.buildAppToken(
        appId: appId,
        appCertificate: appCertificate,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service = parsed.getServices(Service.APAAS).single as ServiceApaas;
      expect(service.roomUuid, isEmpty);
      expect(service.userUuid, isEmpty);
      expect(service.role, -1);
      expect(service.privileges[ServiceApaas.privilegeApp], expireSeconds);
    });
  });
}
