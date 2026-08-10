import 'package:flutter_test/flutter_test.dart';
import 'package:agora_token_generator/agora_token_generator.dart';

void main() {
  const appId = '970CA35de60c44645bbae8a215061b33';
  const appCertificate = '5CFd2fd1755d40ecb72977518be15d3b';
  const channelName = 'stt-channel';
  const rtcAccount = 'stt-rtc-user';
  const rtmUserId = 'stt-rtm-user';
  const rtcTokenExpireSeconds = 3600;
  const joinChannelPrivilegeExpire = 1800;
  const publishAudioPrivilegeExpire = 1700;
  const publishVideoPrivilegeExpire = 1600;
  const publishDataPrivilegeExpire = 1500;
  const rtmTokenExpireSeconds = 1400;

  test('builds a publisher STT token', () {
    final token = SttTokenBuilder.buildToken(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      rtcAccount: rtcAccount,
      rtcRole: RtcRole.publisher,
      rtcTokenExpireSeconds: rtcTokenExpireSeconds,
      joinChannelPrivilegeExpire: joinChannelPrivilegeExpire,
      publishAudioPrivilegeExpire: publishAudioPrivilegeExpire,
      publishVideoPrivilegeExpire: publishVideoPrivilegeExpire,
      publishDataPrivilegeExpire: publishDataPrivilegeExpire,
      rtmUserId: rtmUserId,
      rtmTokenExpireSeconds: rtmTokenExpireSeconds,
    );

    final parsed = AccessToken.empty();
    expect(parsed.parse(token), isTrue);
    final rtc = parsed.getServices(Service.RTC).single as ServiceRtc;
    final rtm = parsed.getServices(Service.RTM).single as ServiceRtm;
    final stt = parsed.getServices(Service.STT).single as ServiceStt;
    expect(parsed.appId, appId);
    expect(parsed.expire, rtcTokenExpireSeconds);
    expect(rtc.channelName, channelName);
    expect(rtc.uid, rtcAccount);
    expect(rtc.privileges, {
      ServiceRtc.privilegeJoinChannel: joinChannelPrivilegeExpire,
      ServiceRtc.privilegePublishAudioStream: publishAudioPrivilegeExpire,
      ServiceRtc.privilegePublishVideoStream: publishVideoPrivilegeExpire,
      ServiceRtc.privilegePublishDataStream: publishDataPrivilegeExpire,
    });
    expect(rtm.userId, rtmUserId);
    expect(rtm.privileges[ServiceRtm.privilegeLogin], rtmTokenExpireSeconds);
    expect(stt.privileges, isEmpty);
  });

  test('builds a subscriber STT token', () {
    final token = SttTokenBuilder.buildToken(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      rtcAccount: rtcAccount,
      rtcRole: RtcRole.subscriber,
      rtcTokenExpireSeconds: rtcTokenExpireSeconds,
      joinChannelPrivilegeExpire: joinChannelPrivilegeExpire,
      publishAudioPrivilegeExpire: publishAudioPrivilegeExpire,
      publishVideoPrivilegeExpire: publishVideoPrivilegeExpire,
      publishDataPrivilegeExpire: publishDataPrivilegeExpire,
      rtmUserId: rtmUserId,
      rtmTokenExpireSeconds: rtmTokenExpireSeconds,
    );

    final parsed = AccessToken.empty();
    expect(parsed.parse(token), isTrue);
    final rtc = parsed.getServices(Service.RTC).single as ServiceRtc;
    expect(rtc.privileges, {
      ServiceRtc.privilegeJoinChannel: joinChannelPrivilegeExpire,
    });
  });
}
