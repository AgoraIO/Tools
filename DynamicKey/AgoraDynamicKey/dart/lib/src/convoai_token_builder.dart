import 'access_token.dart';
import 'rtc_token_builder.dart';

/// Builds ConvoAI tokens with RTC and RTM services.
class ConvoAITokenBuilder {
  /// Builds a ConvoAI token with RTC and RTM services.
  ///
  /// [appId] is the App ID issued by Agora.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the Agora RTC session in string format. The string length
  /// must be less than 64 bytes. The channel name may contain the following characters:
  /// - All lowercase English letters: a to z.
  /// - All uppercase English letters: A to Z.
  /// - All numeric characters: 0 to 9.
  /// - The space character.
  /// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
  /// [account] is the account used by both RTC and RTM and must not exceed 255 bytes.
  /// [tokenExpireSeconds] is the whole token lifetime in seconds from now and defaults to 86400.
  /// [privilegeExpireSeconds] is the RTC and RTM privilege lifetime in seconds from now and defaults to 0.
  /// It must not exceed [tokenExpireSeconds]; otherwise, it is limited by the token expiration time.
  ///
  /// Returns the ConvoAI token.
  static String buildToken({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    int tokenExpireSeconds = 86400,
    int privilegeExpireSeconds = 0,
  }) {
    return buildTokenWithPrivilege(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      rtcAccount: account,
      rtcRole: RtcRole.publisher,
      rtcTokenExpireSeconds: tokenExpireSeconds,
      joinChannelPrivilegeExpire: privilegeExpireSeconds,
      publishAudioPrivilegeExpire: privilegeExpireSeconds,
      publishVideoPrivilegeExpire: privilegeExpireSeconds,
      publishDataPrivilegeExpire: privilegeExpireSeconds,
      rtmUserId: account,
      rtmTokenExpireSeconds: privilegeExpireSeconds,
    );
  }

  /// Builds a ConvoAI token with RTC and RTM services.
  ///
  /// [appId] is the App ID issued by Agora.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the Agora RTC session in string format. The string length
  /// must be less than 64 bytes. The channel name may contain the following characters:
  /// - All lowercase English letters: a to z.
  /// - All uppercase English letters: A to Z.
  /// - All numeric characters: 0 to 9.
  /// - The space character.
  /// - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
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
  /// Returns the ConvoAI token.
  static String buildTokenWithPrivilege({
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

    token.addService(ServiceConvoAI());

    return token.build();
  }
}
