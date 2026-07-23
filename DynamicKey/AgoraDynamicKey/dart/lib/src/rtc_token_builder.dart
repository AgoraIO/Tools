import 'access_token.dart';

/// RtcTokenBuilder class provides static methods to build tokens for RTC services.
class RtcTokenBuilder {
  /// Build a token for Agora RTC service
  ///
  /// @param appId The App ID issued by Agora
  /// @param appCertificate The App Certificate issued by Agora
  /// @param channelName The channel name where the user will join
  /// @param uid The user ID, can be a number or string
  /// @param role (Not used in AccessToken 2.0)
  /// @param tokenExpireSeconds Expiration time of the token in seconds
  /// @returns The generated token
  static String buildTokenWithUid({
    required String appId,
    required String appCertificate,
    required String channelName,
    required int uid,
    required int tokenExpireSeconds,
  }) {
    return buildTokenWithAccount(
      appId: appId,
      appCertificate: appCertificate,
      channelName: channelName,
      account: uid == 0 ? '' : uid.toString(),
      tokenExpireSeconds: tokenExpireSeconds,
    );
  }

  /// Build a token for Agora RTC service using user account
  ///
  /// @param appId The App ID issued by Agora
  /// @param appCertificate The App Certificate issued by Agora
  /// @param channelName The channel name where the user will join
  /// @param account The user account
  /// @param role (Not used in AccessToken 2.0)
  /// @param tokenExpireSeconds Expiration time of the token in seconds
  /// @returns The generated token
  static String buildTokenWithAccount({
    required String appId,
    required String appCertificate,
    required String channelName,
    required String account,
    required int tokenExpireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: tokenExpireSeconds,
    );
    final service = ServiceRtc(channelName, account)
      ..addPrivilege(ServiceRtc.privilegeJoinChannel, tokenExpireSeconds)
      ..addPrivilege(ServiceRtc.privilegePublishAudioStream, tokenExpireSeconds)
      ..addPrivilege(ServiceRtc.privilegePublishVideoStream, tokenExpireSeconds)
      ..addPrivilege(ServiceRtc.privilegePublishDataStream, tokenExpireSeconds);
    token.addService(service);

    return token.build();
  }
}
