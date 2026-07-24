import 'package:agora_token_generator/agora_token_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs Education Token007 Builder tests.
void main() {
  const appId = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const roomUuid = '123';
  const userUuid = '2882341273';
  const role = 1;
  const expireSeconds = 600;

  group('Education Token Builder', () {
    // Verifies room-user tokens contain APaaS, RTM, and Chat privileges.
    test('buildRoomUserToken builds all required services', () {
      final token = EducationTokenBuilder.buildRoomUserToken(
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
      final apaas =
          parsed.getServices(Service.EDUCATION).single as ServiceApaas;
      final rtm = parsed.getServices(Service.RTM).single as ServiceRtm;
      final chat = parsed.getServices(Service.CHAT).single as ServiceChat;
      expect(apaas.roomUuid, roomUuid);
      expect(apaas.userUuid, userUuid);
      expect(apaas.role, role);
      expect(rtm.privileges[ServiceRtm.privilegeLogin], expireSeconds);
      expect(chat.privileges[ServiceChat.privilegeUser], expireSeconds);
    });

    // Verifies Education user tokens use the APaaS user privilege.
    test('buildUserToken builds a user token', () {
      final token = EducationTokenBuilder.buildUserToken(
        appId: appId,
        appCertificate: appCertificate,
        userUuid: userUuid,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service =
          parsed.getServices(Service.EDUCATION).single as ServiceApaas;
      expect(service.userUuid, userUuid);
      expect(service.privileges[ServiceApaas.privilegeUser], expireSeconds);
    });

    // Verifies Education application tokens use the APaaS app privilege.
    test('buildAppToken builds an application token', () {
      final token = EducationTokenBuilder.buildAppToken(
        appId: appId,
        appCertificate: appCertificate,
        expireSeconds: expireSeconds,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service =
          parsed.getServices(Service.EDUCATION).single as ServiceApaas;
      expect(service.userUuid, isEmpty);
      expect(service.privileges[ServiceApaas.privilegeApp], expireSeconds);
    });
  });
}
