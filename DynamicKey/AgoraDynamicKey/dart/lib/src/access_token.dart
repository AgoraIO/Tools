import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class Service {
  static const int RTC = 1;
  static const int RTM = 2;
  static const int CHAT = 3;
  static const int EDUCATION = 4;
}

class Privileges {
  // RTC Privileges
  static const int JOIN_CHANNEL = 1;
  static const int PUBLISH_AUDIO_STREAM = 2;
  static const int PUBLISH_VIDEO_STREAM = 3;
  static const int PUBLISH_DATA_STREAM = 4;

  // RTM Privileges
  static const int LOGIN = 1000;
}

class AccessToken {
  static const int VERSION = 1;
  static const String VERSION_STRING = "007";

  String _appId;
  String _appCertificate;
  String _channelName;
  String _uid;
  late int _ts; // Fixed initialization issue
  late int _salt; // Fixed initialization issue
  Map<int, Map<int, int>> _services = {};
  String _signature = "";
  String _crc = "";

  AccessToken(this._appId, this._appCertificate, this._channelName, this._uid) {
    _ts = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    var random = Random.secure();
    _salt = random.nextInt(0xFFFFFFFF);
  }

  void addPrivilege(int serviceType, int privilegeType, int expireTimestamp) {
    _services[serviceType] = _services[serviceType] ?? {};
    _services[serviceType]![privilegeType] = expireTimestamp;
  }

  String _packUint16(int x) {
    var buffer = Uint8List(2);
    buffer[0] = x >> 8;
    buffer[1] = x & 0xFF;
    return String.fromCharCodes(buffer);
  }

  String _packUint32(int x) {
    var buffer = Uint8List(4);
    buffer[0] = x >> 24;
    buffer[1] = (x >> 16) & 0xFF;
    buffer[2] = (x >> 8) & 0xFF;
    buffer[3] = x & 0xFF;
    return String.fromCharCodes(buffer);
  }

  String _packString(String x) {
    var bytes = utf8.encode(x);
    return _packUint16(bytes.length) + x;
  }

  String _packMapUint32(Map<int, int> x) {
    var keys = x.keys.toList();
    keys.sort();

    String result = _packUint16(keys.length);
    for (var key in keys) {
      result += _packUint16(key);
      result += _packUint32(x[key]!);
    }

    return result;
  }

  String _packMap(Map<int, Map<int, int>> x) {
    var keys = x.keys.toList();
    keys.sort();

    String result = _packUint16(keys.length);
    for (var key in keys) {
      result += _packUint16(key);
      result += _packMapUint32(x[key]!);
    }

    return result;
  }

  String _generateSignature() {
    String signature = VERSION_STRING;
    signature += _packString(_appId);
    signature += _packString(_channelName);
    signature += _packString(_uid);
    signature += _packUint32(_ts);
    signature += _packUint32(_salt);
    signature += _packMap(_services);

    var bytesToSign = utf8.encode(signature);
    var key = utf8.encode(_appCertificate);

    var hmac = Hmac(sha256, key);
    var signatureDigest = hmac.convert(bytesToSign);

    return hex.encode(signatureDigest.bytes);
  }

  String _generateCrc(String signature) {
    List<int> bytesToCrc =
        utf8.encode(_appCertificate + _appId + _channelName + _uid + signature);

    var crc32 = CRC32();
    bytesToCrc.forEach((byte) {
      crc32.update([byte]);
    });

    int crcValue = crc32.finalizeAsInt();
    return crcValue.toRadixString(16).padLeft(8, '0');
  }

  String build() {
    _signature = _generateSignature();
    _crc = _generateCrc(_signature);

    String token = VERSION_STRING;
    token += _crc;
    token += base64.encode(utf8.encode(_appId));
    token += base64.encode(utf8.encode(_channelName));
    token += base64.encode(utf8.encode(_uid));
    token += base64.encode(utf8.encode(_signature));

    return token;
  }
}

// CRC32 implementation
class CRC32 {
  static const int _MASK = 0xFFFFFFFF;
  int _crc = ~0;

  static final List<int> _table = _makeTable();

  static List<int> _makeTable() {
    List<int> table = List<int>.filled(256, 0);

    for (int i = 0; i < 256; i++) {
      int c = i;
      for (int j = 0; j < 8; j++) {
        if ((c & 1) == 1) {
          c = 0xEDB88320 ^ (c >> 1);
        } else {
          c = c >> 1;
        }
      }
      table[i] = c;
    }

    return table;
  }

  void update(List<int> bytes) {
    int crc = _crc;

    for (int i = 0; i < bytes.length; i++) {
      crc = _table[(crc ^ bytes[i]) & 0xFF] ^ (crc >> 8);
    }

    _crc = crc;
  }

  int finalizeAsInt() {
    return (~_crc) & _MASK;
  }
}
