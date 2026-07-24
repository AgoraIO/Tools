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
    // Verifies the existing Dart API keeps publisher privileges by default.
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
      final service = parsed.getServices(Service.RTC).single as ServiceRtc;
      expect(service.privileges, {
        ServiceRtc.privilegeJoinChannel: tokenExpireSeconds,
        ServiceRtc.privilegePublishAudioStream: tokenExpireSeconds,
        ServiceRtc.privilegePublishVideoStream: tokenExpireSeconds,
        ServiceRtc.privilegePublishDataStream: tokenExpireSeconds,
      });
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

    // Verifies subscriber tokens contain only the channel join privilege.
    test('buildTokenWithUid supports subscriber role', () {
      final token = RtcTokenBuilder.buildTokenWithUid(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        uid: uid,
        role: RtcRole.subscriber,
        tokenExpireSeconds: tokenExpireSeconds,
        privilegeExpireSeconds: 500,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final service = parsed.getServices(Service.RTC).single as ServiceRtc;
      expect(service.privileges, {ServiceRtc.privilegeJoinChannel: 500});
    });

    // Verifies every RTC privilege can use an independent expiration value.
    test('buildTokenWithUidAndPrivilege preserves privilege expirations', () {
      final token = RtcTokenBuilder.buildTokenWithUidAndPrivilege(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        uid: uid,
        tokenExpireSeconds: tokenExpireSeconds,
        joinChannelPrivilegeExpire: 100,
        publishAudioPrivilegeExpire: 200,
        publishVideoPrivilegeExpire: 300,
        publishDataPrivilegeExpire: 400,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      final service = parsed.getServices(Service.RTC).single as ServiceRtc;
      expect(service.privileges, {
        ServiceRtc.privilegeJoinChannel: 100,
        ServiceRtc.privilegePublishAudioStream: 200,
        ServiceRtc.privilegePublishVideoStream: 300,
        ServiceRtc.privilegePublishDataStream: 400,
      });
    });

    // Verifies one token can contain RTC and RTM services for one account.
    test('buildTokenWithRtm builds a combined token', () {
      final token = RtcTokenBuilder.buildTokenWithRtm(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        account: uidString,
        role: RtcRole.publisher,
        tokenExpireSeconds: tokenExpireSeconds,
        privilegeExpireSeconds: 500,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.verifySignature(appCertificate), isTrue);
      final rtc = parsed.getServices(Service.RTC).single as ServiceRtc;
      final rtm = parsed.getServices(Service.RTM).single as ServiceRtm;
      expect(rtc.channelName, channelName);
      expect(rtc.uid, uidString);
      expect(rtm.userId, uidString);
      expect(rtm.privileges[ServiceRtm.privilegeLogin], tokenExpireSeconds);
    });

    // Verifies combined RTC and RTM services can use separate identities and
    // expiration values.
    test('buildTokenWithRtm2 preserves separate service settings', () {
      final token = RtcTokenBuilder.buildTokenWithRtm2(
        appId: appId,
        appCertificate: appCertificate,
        channelName: channelName,
        rtcAccount: uidString,
        rtcRole: RtcRole.subscriber,
        rtcTokenExpireSeconds: tokenExpireSeconds,
        joinChannelPrivilegeExpire: 100,
        publishAudioPrivilegeExpire: 200,
        publishVideoPrivilegeExpire: 300,
        publishDataPrivilegeExpire: 400,
        rtmUserId: 'rtm-user',
        rtmTokenExpireSeconds: 700,
      );

      final parsed = AccessToken.empty();
      expect(parsed.parse(token), isTrue);
      expect(parsed.expire, tokenExpireSeconds);
      final rtc = parsed.getServices(Service.RTC).single as ServiceRtc;
      final rtm = parsed.getServices(Service.RTM).single as ServiceRtm;
      expect(rtc.privileges, {ServiceRtc.privilegeJoinChannel: 100});
      expect(rtm.userId, 'rtm-user');
      expect(rtm.privileges[ServiceRtm.privilegeLogin], 700);
    });
  });
}
