import 'access_token.dart';

/// RtmTokenBuilder class provides static methods to build tokens for RTM services.
class RtmTokenBuilder {
  /// Build a token for Agora RTM service
  ///
  /// @param appId The App ID issued by Agora
  /// @param appCertificate The App Certificate issued by Agora
  /// @param userId The user ID for RTM service
  /// @param tokenExpireSeconds Expiration time of the token in seconds
  /// @returns The generated token
  static String buildToken({
    required String appId,
    required String appCertificate,
    required String userId,
    required int tokenExpireSeconds,
  }) {
    AccessToken token = AccessToken(
      appId,
      appCertificate,
      '', // channelName is not used for RTM
      userId,
    );

    int expireTimestamp = _getExpireTimestamp(tokenExpireSeconds);

    // Add RTM privilege
    token.addPrivilege(Service.RTM, Privileges.LOGIN, expireTimestamp);

    return token.build();
  }

  static int _getExpireTimestamp(int tokenExpireSeconds) {
    int currentTimestamp =
        (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    return currentTimestamp + tokenExpireSeconds;
  }
}
