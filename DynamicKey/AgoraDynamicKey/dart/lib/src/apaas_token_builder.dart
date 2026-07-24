import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'access_token.dart';

/// Builds Token007 tokens for APaaS rooms, users, and applications.
class ApaasTokenBuilder {
  /// Builds an APaaS room-user token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [roomUuid] is the room ID and must be unique.
  /// [userUuid] is the user ID and must be unique.
  /// [role] is the user's role.
  /// [expireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated room-user token.
  static String buildRoomUserToken({
    required String appId,
    required String appCertificate,
    required String roomUuid,
    required String userUuid,
    required int role,
    required int expireSeconds,
  }) {
    final token = AccessToken.create(
      appId,
      appCertificate,
      expire: expireSeconds,
    );
    token
      ..addService(
        ServiceApaas(roomUuid, userUuid, role)
          ..addPrivilege(ServiceApaas.privilegeRoomUser, expireSeconds),
      )
      ..addService(
        ServiceRtm(userUuid)
          ..addPrivilege(ServiceRtm.privilegeLogin, expireSeconds),
      )
      ..addService(
        ServiceChat(md5.convert(utf8.encode(userUuid)).toString())
          ..addPrivilege(ServiceChat.privilegeUser, expireSeconds),
      );
    return token.build();
  }

  /// Builds an APaaS user token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [userUuid] is the user ID and must be unique.
  /// [expireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated user token.
  static String buildUserToken({
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
      ServiceApaas('', userUuid, -1)
        ..addPrivilege(ServiceApaas.privilegeUser, expireSeconds),
    );
    return token.build();
  }

  /// Builds an APaaS application token.
  ///
  /// [appId] is the App ID issued by Agora; create one in Agora Dashboard if needed.
  /// [appCertificate] is the certificate of the application registered in Agora Dashboard.
  /// [expireSeconds] is the expiration time in seconds from now; use `600` for 10 minutes.
  ///
  /// Returns the generated application token.
  static String buildAppToken({
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
      ServiceApaas()..addPrivilege(ServiceApaas.privilegeApp, expireSeconds),
    );
    return token.build();
  }
}
