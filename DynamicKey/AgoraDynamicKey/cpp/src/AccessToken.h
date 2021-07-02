#pragma once

#include <zlib.h>
#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include <utility>
#include "cpp/src/utils.h"

namespace agora {
namespace tools {

struct AccessToken {
  enum Privileges {
    kJoinChannel = 1,
    kPublishAudioStream = 2,
    kPublishVideoStream = 3,
    kPublishDataStream = 4,

    kPublishAudiocdn = 5,
    kPublishVideoCdn = 6,
    kRequestPublishAudioStream = 7,
    kRequestPublishVideoStream = 8,
    kRequestPublishDataStream = 9,
    kInvitePublishAudioStream = 10,
    kInvitePublishVideoStream = 11,
    kInvitePublishDataStream = 12,

    kAdministrateChannel = 101,

    kRtmLogin = 1000,
  };

  typedef std::map<uint16_t, uint32_t> PrivilegeMessageMap;

  TOOLS_DECLARE_PACKABLE_3(PrivilegeMessage, uint32_t, salt, uint32_t, ts,
                           PrivilegeMessageMap, messages);

  TOOLS_DECLARE_PACKABLE_4(PackContent, std::string, signature, uint32_t,
                           crcChannelName, uint32_t, crcUid, std::string,
                           rawMessage);

  static std::string Version();
  static std::string GenerateSignature(const std::string& appCertificate,
                                       const std::string& appID,
                                       const std::string& channelName,
                                       const std::string& uid,
                                       const std::string& message);

  AccessToken();
  AccessToken(const std::string& appId, const std::string& appCertificate,
              const std::string& channelName, uint32_t uid = 0);

  AccessToken(const std::string& appId, const std::string& appCertificate,
              const std::string& channelName, const std::string& uid = "");

  void SetTokenExpiredTs(uint32_t seconds);
  std::string Build();
  void AddPrivilege(Privileges privilege, uint32_t expireTimestamp = 0);
  bool FromString(const std::string& channelKeyString);

  std::string app_id_;
  std::string app_cert_;
  std::string channel_name_;
  std::string uid_;
  std::string signature_;
  PrivilegeMessage message_;
  std::string message_raw_content_;
  uint32_t crc_channel_name_;
  uint32_t crc_uid_;
};

inline std::string AccessToken::Version() { 
  return "006";
}

inline std::string AccessToken::GenerateSignature(
    const std::string& appCertificate,
    const std::string& appID,
    const std::string& channelName,
    const std::string& uid,
    const std::string& message) {
  std::stringstream ss;
  ss << appID << channelName << uid << message;
  return (HmacSign2(appCertificate, ss.str(), HMAC_SHA256_LENGTH));
}

inline AccessToken::AccessToken() : crc_channel_name_(0), crc_uid_(0) {
}

inline AccessToken::AccessToken(const std::string& appId,
    const std::string& appCertificate,
    const std::string& channelName,
    uint32_t uid) :
  app_id_(appId),
  app_cert_(appCertificate),
  channel_name_(channelName),
  crc_channel_name_(0),
  crc_uid_(0) {
    std::stringstream uidStr;
    if (uid == 0) {
      uidStr << "";
    } else {
      uidStr << uid;
    }
    uid_ = uidStr.str();
    uint32_t now = ::time(NULL);
    message_.salt = GenerateSalt();
    message_.ts = now + 24 * 3600;
  }

inline AccessToken::AccessToken(const std::string& appId,
    const std::string& appCertificate,
    const std::string& channelName,
    const std::string& uid) :
  app_id_(appId),
  app_cert_(appCertificate),
  channel_name_(channelName),
  uid_(uid),
  crc_channel_name_(0),
  crc_uid_(0) {
    uint32_t now = ::time(NULL);
    message_.salt = GenerateSalt();
    message_.ts = now + 24 * 3600;
  }

inline std::string AccessToken::Build() {
  if (!IsUUID(app_id_)) {
    perror("invalid appID");
    return "";
  }

  if (!IsUUID(app_cert_)) {
    perror("invalid appCertificate");
    return "";
  }
  message_raw_content_ = Pack(message_);
  signature_ = GenerateSignature(app_cert_, app_id_, channel_name_, uid_,
      message_raw_content_);
  crc_channel_name_ = crc32(
      0, reinterpret_cast<Bytef*>(const_cast<char*>(channel_name_.c_str())),
      channel_name_.length());
  crc_uid_ =
    crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>(uid_.c_str())),
        uid_.length());
  PackContent content;
  content.signature = signature_;
  content.crcChannelName = crc_channel_name_;
  content.crcUid = crc_uid_;
  content.rawMessage = message_raw_content_;
  std::stringstream ss;
  ss << AccessToken::Version() << app_id_ << base64Encode(Pack(content));
  return ss.str();
}

inline bool AccessToken::FromString(const std::string& channelKeyString) {
  if (channelKeyString.substr(0, VERSION_LENGTH) != Version()) {
    return false;
  }
  try {
    app_id_ = channelKeyString.substr(VERSION_LENGTH, APP_ID_LENGTH);
    PackContent content;
    Unpack(base64Decode(channelKeyString.substr(
            VERSION_LENGTH + APP_ID_LENGTH, channelKeyString.size())),
        content);
    signature_ = content.signature;
    crc_channel_name_ = content.crcChannelName;
    crc_uid_ = content.crcUid;
    message_raw_content_ = content.rawMessage;
    Unpack(message_raw_content_, message_);
  } catch (std::exception& e) {
    return false;
  }
  return true;
}

inline void AccessToken::AddPrivilege(Privileges privilege, uint32_t expireTimestamp) {
  message_.messages[privilege] = expireTimestamp;
}

inline void AccessToken::SetTokenExpiredTs(uint32_t seconds) {
  message_.ts = ::time(NULL) + seconds;
}
}  // namespace tools
}  // namespace agora
