// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

/// Represents the common ServiceType and privilege payload.
class Service {
  static const int RTC = 1;
  static const int RTM = 2;
  static const int FPA = 4;
  static const int CHAT = 5;
  static const int APAAS = 7;
  static const int EDUCATION = APAAS;

  final int serviceType;
  Map<int, int> privileges = <int, int>{};

  /// Creates a service with the specified numeric ServiceType.
  Service(this.serviceType);

  /// Adds or updates a privilege expiration value.
  void addPrivilege(int privilege, int expire) {
    privileges[privilege] = expire;
  }

  /// Serializes the ServiceType and privilege map.
  Uint8List pack() {
    final writer = _ByteWriter()
      ..putUint16(serviceType)
      ..putMapUint32(privileges);
    return writer.toBytes();
  }

  /// Deserializes privileges after the ServiceType has been consumed.
  void _unpack(_ByteReader reader) {
    privileges = reader.readMapUint32();
  }
}

/// Defines RTC and RTM privilege identifiers retained for source compatibility.
class Privileges {
  static const int JOIN_CHANNEL = 1;
  static const int PUBLISH_AUDIO_STREAM = 2;
  static const int PUBLISH_VIDEO_STREAM = 3;
  static const int PUBLISH_DATA_STREAM = 4;
  static const int LOGIN = 1;
}

/// Represents an RTC service payload.
class ServiceRtc extends Service {
  static const int privilegeJoinChannel = 1;
  static const int privilegePublishAudioStream = 2;
  static const int privilegePublishVideoStream = 3;
  static const int privilegePublishDataStream = 4;

  String channelName;
  String uid;

  /// Creates an RTC service for a channel and user ID.
  ServiceRtc([this.channelName = '', Object uid = ''])
      : uid = uid == 0 ? '' : uid.toString(),
        super(Service.RTC);

  /// Serializes the RTC service payload.
  @override
  Uint8List pack() {
    final writer = _ByteWriter()
      ..putBytes(super.pack())
      ..putString(channelName)
      ..putString(uid);
    return writer.toBytes();
  }

  /// Deserializes the RTC service payload.
  @override
  void _unpack(_ByteReader reader) {
    super._unpack(reader);
    channelName = reader.readString();
    uid = reader.readString();
  }
}

/// Represents an RTM service payload.
class ServiceRtm extends Service {
  static const int privilegeLogin = 1;

  String userId;

  /// Creates an RTM service for a user ID.
  ServiceRtm([this.userId = '']) : super(Service.RTM);

  /// Serializes the RTM service payload.
  @override
  Uint8List pack() {
    final writer = _ByteWriter()
      ..putBytes(super.pack())
      ..putString(userId);
    return writer.toBytes();
  }

  /// Deserializes the RTM service payload.
  @override
  void _unpack(_ByteReader reader) {
    super._unpack(reader);
    userId = reader.readString();
  }
}

/// Represents an FPA service payload.
class ServiceFpa extends Service {
  static const int privilegeLogin = 1;

  /// Creates an FPA service.
  ServiceFpa() : super(Service.FPA);
}

/// Represents a Chat service payload.
class ServiceChat extends Service {
  static const int privilegeUser = 1;
  static const int privilegeApp = 2;

  String userId;

  /// Creates a Chat service for a user ID.
  ServiceChat([this.userId = '']) : super(Service.CHAT);

  /// Serializes the Chat service payload.
  @override
  Uint8List pack() {
    final writer = _ByteWriter()
      ..putBytes(super.pack())
      ..putString(userId);
    return writer.toBytes();
  }

  /// Deserializes the Chat service payload.
  @override
  void _unpack(_ByteReader reader) {
    super._unpack(reader);
    userId = reader.readString();
  }
}

/// Represents an APaaS service payload.
class ServiceApaas extends Service {
  static const int privilegeRoomUser = 1;
  static const int privilegeUser = 2;
  static const int privilegeApp = 3;

  String roomUuid;
  String userUuid;
  int role;

  /// Creates an APaaS service for a room, user, and role.
  ServiceApaas([this.roomUuid = '', this.userUuid = '', this.role = -1])
      : super(Service.APAAS);

  /// Serializes the APaaS service payload.
  @override
  Uint8List pack() {
    final writer = _ByteWriter()
      ..putBytes(super.pack())
      ..putString(roomUuid)
      ..putString(userUuid)
      ..putInt16(role);
    return writer.toBytes();
  }

  /// Deserializes the APaaS service payload.
  @override
  void _unpack(_ByteReader reader) {
    super._unpack(reader);
    roomUuid = reader.readString();
    userUuid = reader.readString();
    role = reader.readInt16();
  }
}

/// Builds, parses, and verifies Token007 tokens containing one or more services.
class AccessToken {
  static const int VERSION = 1;
  static const String VERSION_STRING = '007';
  static const int _versionLength = 3;

  String appId;
  String appCertificate;
  int issueTs;
  int expire;
  int salt;
  final List<Service> services = <Service>[];

  final String _legacyChannelName;
  final String _legacyUid;
  Uint8List _signature = Uint8List(0);
  Uint8List _signingInfo = Uint8List(0);

  /// Creates a token using the legacy low-level constructor.
  AccessToken(
    this.appId,
    this.appCertificate,
    this._legacyChannelName,
    Object uid,
  )   : _legacyUid = uid == 0 ? '' : uid.toString(),
        issueTs = _timestamp(),
        expire = 0,
        salt = _generateSalt();

  /// Creates a Token007 builder with explicit token expiration.
  AccessToken.create(
    this.appId,
    this.appCertificate, {
    required this.expire,
    int? issueTs,
    int? salt,
  })  : _legacyChannelName = '',
        _legacyUid = '',
        issueTs = issueTs ?? _timestamp(),
        salt = salt ?? _generateSalt();

  /// Creates an empty Token007 parser.
  AccessToken.empty() : this.create('', '', expire: 0);

  /// Adds a service without replacing existing services of the same type.
  void addService(Service service) {
    services.add(service);
  }

  /// Returns all services of the requested type in insertion or token order.
  List<Service> getServices(int serviceType) {
    return services
        .where((service) => service.serviceType == serviceType)
        .toList();
  }

  /// Adds a privilege through the legacy low-level API.
  void addPrivilege(int serviceType, int privilegeType, int expireValue) {
    Service? service;
    for (final candidate in services) {
      if (candidate.serviceType == serviceType) {
        service = candidate;
        break;
      }
    }

    service ??= _createLegacyService(serviceType);
    if (!services.contains(service)) {
      addService(service);
    }
    service.addPrivilege(privilegeType, expireValue);
  }

  /// Builds a standard Token007 token containing all added services.
  String build() {
    if (!_isUuid(appId) || !_isUuid(appCertificate) || services.isEmpty) {
      return '';
    }

    final servicesToPack = _servicesForPacking();
    final signingWriter = _ByteWriter()
      ..putString(appId)
      ..putUint32(issueTs)
      ..putUint32(expire)
      ..putUint32(salt)
      ..putUint16(servicesToPack.length);
    for (final service in servicesToPack) {
      signingWriter.putBytes(service.pack());
    }

    final signingInfo = signingWriter.toBytes();
    final signature = _hmac(_signing(appCertificate), signingInfo);
    final content = (_ByteWriter()
          ..putLengthPrefixedBytes(signature)
          ..putBytes(signingInfo))
        .toBytes();
    final compressed = ZLibEncoder().encode(content);
    return VERSION_STRING + base64Encode(compressed);
  }

  /// Parses known services and retains original bytes for signature verification.
  bool parse(String? token) {
    if (token == null ||
        token.length < _versionLength ||
        !token.startsWith(VERSION_STRING)) {
      return false;
    }

    try {
      final compressed = base64Decode(token.substring(_versionLength));
      final content = Uint8List.fromList(ZLibDecoder().decodeBytes(compressed));
      final reader = _ByteReader(content);
      final signature = reader.readLengthPrefixedBytes();
      final signingInfo = reader.remainingBytes();
      final parsedAppId = reader.readString();
      final parsedIssueTs = reader.readUint32();
      final parsedExpire = reader.readUint32();
      final parsedSalt = reader.readUint32();
      final serviceCount = reader.readUint16();
      final parsedServices = <Service>[];

      for (var index = 0; index < serviceCount; index++) {
        final serviceType = reader.readUint16();
        final service = _createKnownService(serviceType);
        if (service == null) {
          _applyParsedFields(
            parsedAppId,
            parsedIssueTs,
            parsedExpire,
            parsedSalt,
            signature,
            signingInfo,
            parsedServices,
          );
          return true;
        }
        service._unpack(reader);
        parsedServices.add(service);
      }

      _applyParsedFields(
        parsedAppId,
        parsedIssueTs,
        parsedExpire,
        parsedSalt,
        signature,
        signingInfo,
        parsedServices,
      );
      return true;
    } on Object {
      return false;
    }
  }

  /// Verifies the signature of a successfully parsed token.
  bool verifySignature(String appCertificate) {
    if (_signature.isEmpty ||
        _signingInfo.isEmpty ||
        !_isUuid(appId) ||
        !_isUuid(appCertificate)) {
      return false;
    }

    final expected = _hmac(_signing(appCertificate), _signingInfo);
    return _constantTimeEquals(_signature, expected);
  }

  /// Returns services in stable ServiceType order.
  List<Service> _servicesForPacking() {
    final indexed = services.indexed.toList()
      ..sort((left, right) {
        final typeDifference =
            left.$2.serviceType.compareTo(right.$2.serviceType);
        return typeDifference != 0
            ? typeDifference
            : left.$1.compareTo(right.$1);
      });
    return indexed.map((entry) => entry.$2).toList();
  }

  /// Derives the Token007 signing key from timestamp, salt, and certificate.
  Uint8List _signing(String certificate) {
    final issueTsBytes = (_ByteWriter()..putUint32(issueTs)).toBytes();
    final signing = _hmac(issueTsBytes, utf8.encode(certificate));
    final saltBytes = (_ByteWriter()..putUint32(salt)).toBytes();
    return _hmac(saltBytes, signing);
  }

  /// Creates a service for the legacy privilege API.
  Service _createLegacyService(int serviceType) {
    switch (serviceType) {
      case Service.RTC:
        return ServiceRtc(_legacyChannelName, _legacyUid);
      case Service.RTM:
        return ServiceRtm(_legacyUid);
      case Service.FPA:
        return ServiceFpa();
      case Service.CHAT:
        return ServiceChat(_legacyUid);
      case Service.APAAS:
        return ServiceApaas('', _legacyUid);
      default:
        return Service(serviceType);
    }
  }

  /// Replaces the current token state with successfully parsed fields.
  void _applyParsedFields(
    String parsedAppId,
    int parsedIssueTs,
    int parsedExpire,
    int parsedSalt,
    Uint8List signature,
    Uint8List signingInfo,
    List<Service> parsedServices,
  ) {
    appId = parsedAppId;
    issueTs = parsedIssueTs;
    expire = parsedExpire;
    salt = parsedSalt;
    _signature = signature;
    _signingInfo = signingInfo;
    services
      ..clear()
      ..addAll(parsedServices);
  }

  /// Returns the current Unix timestamp in seconds.
  static int _timestamp() {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  /// Returns a random unsigned 32-bit salt.
  static int _generateSalt() {
    return Random.secure().nextInt(0xffffffff) + 1;
  }
}

/// Creates a known service or returns null for an unknown ServiceType.
Service? _createKnownService(int serviceType) {
  switch (serviceType) {
    case Service.RTC:
      return ServiceRtc();
    case Service.RTM:
      return ServiceRtm();
    case Service.FPA:
      return ServiceFpa();
    case Service.CHAT:
      return ServiceChat();
    case Service.APAAS:
      return ServiceApaas();
    default:
      return null;
  }
}

/// Returns whether a value is a 32-character hexadecimal identifier.
bool _isUuid(String value) {
  return RegExp(r'^[0-9a-fA-F]{32}$').hasMatch(value);
}

/// Returns a SHA-256 HMAC digest.
Uint8List _hmac(List<int> key, List<int> message) {
  return Uint8List.fromList(Hmac(sha256, key).convert(message).bytes);
}

/// Compares byte sequences without returning early on content differences.
bool _constantTimeEquals(List<int> left, List<int> right) {
  if (left.length != right.length) {
    return false;
  }

  var difference = 0;
  for (var index = 0; index < left.length; index++) {
    difference |= left[index] ^ right[index];
  }
  return difference == 0;
}

/// Writes little-endian Token007 values.
class _ByteWriter {
  final BytesBuilder _builder = BytesBuilder(copy: false);

  /// Appends an unsigned 16-bit integer.
  void putUint16(int value) {
    final data = ByteData(2)..setUint16(0, value, Endian.little);
    _builder.add(data.buffer.asUint8List());
  }

  /// Appends a signed 16-bit integer.
  void putInt16(int value) {
    final data = ByteData(2)..setInt16(0, value, Endian.little);
    _builder.add(data.buffer.asUint8List());
  }

  /// Appends an unsigned 32-bit integer.
  void putUint32(int value) {
    final data = ByteData(4)..setUint32(0, value, Endian.little);
    _builder.add(data.buffer.asUint8List());
  }

  /// Appends raw bytes.
  void putBytes(List<int> value) {
    _builder.add(value);
  }

  /// Appends length-prefixed bytes.
  void putLengthPrefixedBytes(List<int> value) {
    putUint16(value.length);
    putBytes(value);
  }

  /// Appends a UTF-8 string with an unsigned 16-bit length prefix.
  void putString(String value) {
    putLengthPrefixedBytes(utf8.encode(value));
  }

  /// Appends an unsigned 32-bit map in numeric key order.
  void putMapUint32(Map<int, int> value) {
    final keys = value.keys.toList()..sort();
    putUint16(keys.length);
    for (final key in keys) {
      putUint16(key);
      putUint32(value[key]!);
    }
  }

  /// Returns all written bytes.
  Uint8List toBytes() {
    return _builder.toBytes();
  }
}

/// Reads little-endian Token007 values with bounds checks.
class _ByteReader {
  final Uint8List _bytes;
  int offset = 0;

  /// Creates a reader over the supplied bytes.
  _ByteReader(this._bytes);

  /// Reads an unsigned 16-bit integer.
  int readUint16() {
    _ensureAvailable(2);
    final value = ByteData.sublistView(_bytes).getUint16(offset, Endian.little);
    offset += 2;
    return value;
  }

  /// Reads a signed 16-bit integer.
  int readInt16() {
    _ensureAvailable(2);
    final value = ByteData.sublistView(_bytes).getInt16(offset, Endian.little);
    offset += 2;
    return value;
  }

  /// Reads an unsigned 32-bit integer.
  int readUint32() {
    _ensureAvailable(4);
    final value = ByteData.sublistView(_bytes).getUint32(offset, Endian.little);
    offset += 4;
    return value;
  }

  /// Reads length-prefixed bytes.
  Uint8List readLengthPrefixedBytes() {
    final length = readUint16();
    _ensureAvailable(length);
    final value = Uint8List.fromList(_bytes.sublist(offset, offset + length));
    offset += length;
    return value;
  }

  /// Reads a UTF-8 string with an unsigned 16-bit length prefix.
  String readString() {
    return utf8.decode(readLengthPrefixedBytes());
  }

  /// Reads an unsigned 32-bit value map.
  Map<int, int> readMapUint32() {
    final length = readUint16();
    final result = <int, int>{};
    for (var index = 0; index < length; index++) {
      result[readUint16()] = readUint32();
    }
    return result;
  }

  /// Returns unread bytes without advancing the reader.
  Uint8List remainingBytes() {
    return Uint8List.fromList(_bytes.sublist(offset));
  }

  /// Throws when the requested number of bytes is unavailable.
  void _ensureAvailable(int length) {
    if (length < 0 || offset + length > _bytes.length) {
      throw const FormatException('invalid Token007 payload');
    }
  }
}
