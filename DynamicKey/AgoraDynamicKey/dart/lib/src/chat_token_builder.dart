import 'access_token.dart';

/// Builds Token007 tokens for Chat users and applications.
class ChatTokenBuilder {
  /// Builds a Chat user token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [userUuid] is the user's ID and must be unique.
  /// [expireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated Chat user token.
  static String buildChatUserToken({
    required String appId,
    required String appCertificate,
    required String userUuid,
    required int expireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: expireSeconds,
    );
    token.addService(
      ServiceChat(userUuid)
        ..addPrivilege(ServiceChat.privilegeUser, expireSeconds),
    );
    return token.build();
  }

  /// Builds a Chat application token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [expireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated Chat application token.
  static String buildChatAppToken({
    required String appId,
    required String appCertificate,
    required int expireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: expireSeconds,
    );
    token.addService(
      ServiceChat()..addPrivilege(ServiceChat.privilegeApp, expireSeconds),
    );
    return token.build();
  }
}
