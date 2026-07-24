import 'access_token.dart';

/// Builds Token007 tokens for RTM services.
class RtmTokenBuilder {
  /// Builds an RTM token for a user account.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [userId] is the user's account and must not exceed 64 bytes.
  /// [tokenExpireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated RTM token.
  static String buildToken({
    required String appId,
    required String appCertificate,
    required String userId,
    required int tokenExpireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: tokenExpireSeconds,
    );
    final service = ServiceRtm(userId)
      ..addPrivilege(ServiceRtm.privilegeLogin, tokenExpireSeconds);
    token.addService(service);

    return token.build();
  }
}
