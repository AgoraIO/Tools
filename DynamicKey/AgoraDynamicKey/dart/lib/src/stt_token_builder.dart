import 'access_token.dart';
import 'rtc_token_builder.dart';

/// Builds Token007 tokens for RTC, RTM, and STT services.
class SttTokenBuilder {
  /// Builds a Token007 that carries RTC, RTM, and STT services.
  ///
  /// [appId] is the App ID issued by Agora.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [rtcAccount] is the RTC user account and must not exceed 255 bytes.
  /// [rtcRole] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [rtcTokenExpireSeconds] is the number of seconds from now until the token expires. This is the whole
  /// token expiration. The whole token is invalid after this time, even if a privilege expiration time is
  /// later.
  /// [joinChannelPrivilegeExpire] is the number of seconds from now until the join privilege expires. This
  /// value must not exceed the token expiration value; otherwise, the privilege is limited by the token
  /// expiration time.
  /// [publishAudioPrivilegeExpire] is the number of seconds from now until the audio publishing privilege
  /// expires. This value must not exceed the token expiration value; otherwise, the privilege is limited by
  /// the token expiration time.
  /// [publishVideoPrivilegeExpire] is the number of seconds from now until the video publishing privilege
  /// expires. This value must not exceed the token expiration value; otherwise, the privilege is limited by
  /// the token expiration time.
  /// [publishDataPrivilegeExpire] is the number of seconds from now until the data publishing privilege
  /// expires. This value must not exceed the token expiration value; otherwise, the privilege is limited by
  /// the token expiration time.
  /// [rtmUserId] is the RTM user account and must not exceed 255 bytes.
  /// [rtmTokenExpireSeconds] is the number of seconds from now until the RTM privilege expires. This value
  /// must not exceed the RTC token expiration value; otherwise, the RTM login privilege is limited by the
  /// token expiration time.
  ///
  /// Returns the generated RTC, RTM, and STT token.
  static String buildToken({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String rtcAccount,
    required RtcRole rtcRole,
    required int rtcTokenExpireSeconds,
    required int joinChannelPrivilegeExpire,
    required int publishAudioPrivilegeExpire,
    required int publishVideoPrivilegeExpire,
    required int publishDataPrivilegeExpire,
    required String rtmUserId,
    required int rtmTokenExpireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: rtcTokenExpireSeconds,
    );

    final serviceRtc = ServiceRtc(channelName, rtcAccount)
      ..addPrivilege(
        ServiceRtc.privilegeJoinChannel,
        joinChannelPrivilegeExpire,
      );
    if (rtcRole == RtcRole.publisher) {
      serviceRtc
        ..addPrivilege(
          ServiceRtc.privilegePublishAudioStream,
          publishAudioPrivilegeExpire,
        )
        ..addPrivilege(
          ServiceRtc.privilegePublishVideoStream,
          publishVideoPrivilegeExpire,
        )
        ..addPrivilege(
          ServiceRtc.privilegePublishDataStream,
          publishDataPrivilegeExpire,
        );
    }
    token.addService(serviceRtc);

    final serviceRtm = ServiceRtm(rtmUserId)
      ..addPrivilege(ServiceRtm.privilegeLogin, rtmTokenExpireSeconds);
    token.addService(serviceRtm);

    token.addService(ServiceStt());

    return token.build();
  }
}
