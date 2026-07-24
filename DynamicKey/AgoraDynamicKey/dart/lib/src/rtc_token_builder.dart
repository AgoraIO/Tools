import 'access_token.dart';

/// Defines the RTC role used to select token privileges.
enum RtcRole {
  /// Recommended for voice/video calls and live broadcasts when
  /// [co-host authentication](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication)
  /// is not required.
  publisher,

  /// Use only when
  /// [co-host authentication](https://docs.agora.io/en/video-calling/get-started/authentication-workflow?#co-host-token-authentication)
  /// is required. Contact Agora support to enable it; otherwise this role has
  /// the same privileges as the publisher role.
  subscriber,
}

/// Builds Token007 tokens for RTC and combined RTC/RTM services.
class RtcTokenBuilder {
  /// Builds an RTC token for a numeric user ID.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [uid] is a unique unsigned 32-bit user ID; use `0` to allow any user ID.
  /// [role] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [privilegeExpireSeconds] is the number of seconds from now until the RTC privileges expire; it defaults to the token lifetime.
  ///
  /// Returns the generated RTC token.
  static String buildTokenWithUid({
    required String appId,
    required String appCertificate,
    required String channelName,
    required int uid,
    required int tokenExpireSeconds,
    RtcRole role = RtcRole.publisher,
    int? privilegeExpireSeconds,
  }) {
    return buildTokenWithUserAccount(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      account: uid == 0 ? '' : uid.toString(),
      role: role,
      tokenExpireSeconds: tokenExpireSeconds,
      privilegeExpireSeconds: privilegeExpireSeconds ?? tokenExpireSeconds,
    );
  }

  /// Builds an RTC token for a user account.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [account] is the user's account and must not exceed 255 bytes.
  /// [role] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [privilegeExpireSeconds] is the number of seconds from now until the RTC privileges expire; it defaults to the token lifetime.
  ///
  /// Returns the generated RTC token.
  static String buildTokenWithUserAccount({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    required int tokenExpireSeconds,
    RtcRole role = RtcRole.publisher,
    int? privilegeExpireSeconds,
  }) {
    final privilegeExpire = privilegeExpireSeconds ?? tokenExpireSeconds;
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: tokenExpireSeconds,
    );

    final serviceRtc = ServiceRtc(channelName, account);
    serviceRtc.addPrivilege(
      ServiceRtc.privilegeJoinChannel,
      privilegeExpire,
    );
    if (role == RtcRole.publisher) {
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishAudioStream,
        privilegeExpire,
      );
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishVideoStream,
        privilegeExpire,
      );
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishDataStream,
        privilegeExpire,
      );
    }
    token.addService(serviceRtc);

    return token.build();
  }

  /// Builds an RTC token for a user account using the original Dart API name.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [account] is the user's account and must not exceed 255 bytes.
  /// [role] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [privilegeExpireSeconds] is the number of seconds from now until the RTC privileges expire; it defaults to the token lifetime.
  ///
  /// This compatibility alias behaves like [buildTokenWithUserAccount].
  static String buildTokenWithAccount({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    required int tokenExpireSeconds,
    RtcRole role = RtcRole.publisher,
    int? privilegeExpireSeconds,
  }) {
    return buildTokenWithUserAccount(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      account: account,
      role: role,
      tokenExpireSeconds: tokenExpireSeconds,
      privilegeExpireSeconds: privilegeExpireSeconds,
    );
  }

  /// Builds an RTC token with independent privilege expiration values for a
  /// numeric user ID.
  ///
  /// The token supports channel join and audio, video, and data publishing
  /// privileges. Publishing privileges apply only when co-host authentication
  /// is enabled. Each privilege can be valid for up to 24 hours.
  ///
  /// [appId] is the App ID issued by Agora.
  /// [appCertificate] is the App Certificate of the Agora project.
  /// [channelName] is the unique RTC channel name and must be less than 64 bytes.
  /// [uid] is a unique unsigned 32-bit user ID; use `0` to allow any user ID.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [joinChannelPrivilegeExpire] is the number of seconds from now until the channel join privilege expires.
  /// [publishAudioPrivilegeExpire] is the number of seconds from now until the audio publishing privilege expires.
  /// [publishVideoPrivilegeExpire] is the number of seconds from now until the video publishing privilege expires.
  /// [publishDataPrivilegeExpire] is the number of seconds from now until the data publishing privilege expires.
  ///
  /// Returns the generated RTC token.
  static String buildTokenWithUidAndPrivilege({
    required String appId,
    required String appCertificate,
    required String channelName,
    required int uid,
    required int tokenExpireSeconds,
    required int joinChannelPrivilegeExpire,
    required int publishAudioPrivilegeExpire,
    required int publishVideoPrivilegeExpire,
    required int publishDataPrivilegeExpire,
  }) {
    return buildTokenWithUserAccountAndPrivilege(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      account: uid == 0 ? '' : uid.toString(),
      tokenExpireSeconds: tokenExpireSeconds,
      joinChannelPrivilegeExpire: joinChannelPrivilegeExpire,
      publishAudioPrivilegeExpire: publishAudioPrivilegeExpire,
      publishVideoPrivilegeExpire: publishVideoPrivilegeExpire,
      publishDataPrivilegeExpire: publishDataPrivilegeExpire,
    );
  }

  /// Builds an RTC token with independent privilege expiration values for a
  /// user account.
  ///
  /// The token supports channel join and audio, video, and data publishing
  /// privileges. Publishing privileges apply only when co-host authentication
  /// is enabled. Each privilege can be valid for up to 24 hours.
  ///
  /// [appId] is the App ID issued by Agora.
  /// [appCertificate] is the App Certificate of the Agora project.
  /// [channelName] is the unique RTC channel name and must be less than 64 bytes.
  /// [account] is the user account.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [joinChannelPrivilegeExpire] is the number of seconds from now until the channel join privilege expires.
  /// [publishAudioPrivilegeExpire] is the number of seconds from now until the audio publishing privilege expires.
  /// [publishVideoPrivilegeExpire] is the number of seconds from now until the video publishing privilege expires.
  /// [publishDataPrivilegeExpire] is the number of seconds from now until the data publishing privilege expires.
  ///
  /// Returns the generated RTC token.
  static String buildTokenWithUserAccountAndPrivilege({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    required int tokenExpireSeconds,
    required int joinChannelPrivilegeExpire,
    required int publishAudioPrivilegeExpire,
    required int publishVideoPrivilegeExpire,
    required int publishDataPrivilegeExpire,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: tokenExpireSeconds,
    );

    final serviceRtc = ServiceRtc(channelName, account);
    serviceRtc.addPrivilege(
      ServiceRtc.privilegeJoinChannel,
      joinChannelPrivilegeExpire,
    );
    serviceRtc.addPrivilege(
      ServiceRtc.privilegePublishAudioStream,
      publishAudioPrivilegeExpire,
    );
    serviceRtc.addPrivilege(
      ServiceRtc.privilegePublishVideoStream,
      publishVideoPrivilegeExpire,
    );
    serviceRtc.addPrivilege(
      ServiceRtc.privilegePublishDataStream,
      publishDataPrivilegeExpire,
    );
    token.addService(serviceRtc);

    return token.build();
  }

  /// Builds one Token007 token containing RTC and RTM services for the same
  /// account.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [account] is the user's account and must not exceed 255 bytes.
  /// [role] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [tokenExpireSeconds] is the number of seconds from now until the token expires; use `600` for 10 minutes.
  /// [privilegeExpireSeconds] is the number of seconds from now until the RTC privileges expire; use `600` for 10 minutes.
  ///
  /// Returns the generated RTC and RTM token.
  static String buildTokenWithRtm({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    required RtcRole role,
    required int tokenExpireSeconds,
    required int privilegeExpireSeconds,
  }) {
    return buildTokenWithRtm2(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      rtcAccount: account,
      rtcRole: role,
      rtcTokenExpireSeconds: tokenExpireSeconds,
      joinChannelPrivilegeExpire: privilegeExpireSeconds,
      publishAudioPrivilegeExpire: privilegeExpireSeconds,
      publishVideoPrivilegeExpire: privilegeExpireSeconds,
      publishDataPrivilegeExpire: privilegeExpireSeconds,
      rtmUserId: account,
      rtmTokenExpireSeconds: tokenExpireSeconds,
    );
  }

  /// Builds one Token007 token containing RTC and RTM services with separate
  /// accounts and expiration values.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [channelName] is the unique channel name for the RTC session.
  /// [rtcAccount] is the RTC user's account and must not exceed 255 bytes.
  /// [rtcRole] is [RtcRole.publisher] for a broadcaster or [RtcRole.subscriber] for an audience member.
  /// [rtcTokenExpireSeconds] is the number of seconds from now until the RTC token expires; use `600` for 10 minutes.
  /// [joinChannelPrivilegeExpire] is the number of seconds from now until the channel join privilege expires.
  /// [publishAudioPrivilegeExpire] is the number of seconds from now until the audio publishing privilege expires.
  /// [publishVideoPrivilegeExpire] is the number of seconds from now until the video publishing privilege expires.
  /// [publishDataPrivilegeExpire] is the number of seconds from now until the data publishing privilege expires.
  /// [rtmUserId] is the RTM user's account and must not exceed 255 bytes.
  /// [rtmTokenExpireSeconds] is the number of seconds from now until the RTM token expires; use `600` for 10 minutes.
  ///
  /// Returns the generated RTC and RTM token.
  static String buildTokenWithRtm2({
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

    final serviceRtc = ServiceRtc(channelName, rtcAccount);
    serviceRtc.addPrivilege(
      ServiceRtc.privilegeJoinChannel,
      joinChannelPrivilegeExpire,
    );
    if (rtcRole == RtcRole.publisher) {
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishAudioStream,
        publishAudioPrivilegeExpire,
      );
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishVideoStream,
        publishVideoPrivilegeExpire,
      );
      serviceRtc.addPrivilege(
        ServiceRtc.privilegePublishDataStream,
        publishDataPrivilegeExpire,
      );
    }
    token.addService(serviceRtc);

    token.addService(
      ServiceRtm(rtmUserId)
        ..addPrivilege(
          ServiceRtm.privilegeLogin,
          rtmTokenExpireSeconds,
        ),
    );
    return token.build();
  }
}
