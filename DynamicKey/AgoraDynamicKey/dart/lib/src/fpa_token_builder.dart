import 'access_token.dart';

/// Builds Token007 tokens for FPA login.
class FpaTokenBuilder {
  static const int _tokenExpireSeconds = 24 * 60 * 60;

  /// Builds an FPA token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  ///
  /// Returns the generated FPA token.
  static String buildToken({
    required String appId,
    required String appCertificate,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: _tokenExpireSeconds,
    );
    token.addService(
      ServiceFpa()..addPrivilege(ServiceFpa.privilegeLogin, 0),
    );
    return token.build();
  }
}
