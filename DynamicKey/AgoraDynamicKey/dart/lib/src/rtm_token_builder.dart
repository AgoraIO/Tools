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
