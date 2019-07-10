#pragma once

#include <zlib.h>
#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include <utility>
#include "cpp/src/AccessToken.h"

namespace agora {
namespace tools {

enum UserRole {
  Role_Attendee = 0,    // deprecated ,same as publisher
  Role_Publisher = 1,   // for live broadcast broadcaster
  Role_Subscriber = 2,  // default, for live broadcast audience
  Role_Admin = 101,     // deprecated ,same as publisher
};

class SimpleTokenBuilder2 {
 public:
  static std::string buildTokenWithUid(const std::string& appId,
                                  const std::string& appCertificate,
                                  const std::string& channelName,
                                  uint32_t uid,
                                  UserRole role,
                                  uint32_t expiredTs = 0);
  static std::string buildTokenWithUserAccount(const std::string& appId,
                                          const std::string& appCertificate,
                                          const std::string& channelName,
                                          const std::string& userAccount,
                                          UserRole role,
                                          uint32_t expiredTs = 0);
};

std::string SimpleTokenBuilder2::buildTokenWithUid(
                                  const std::string& appId,
                                  const std::string& appCertificate,
                                  const std::string& channelName,
                                  uint32_t uid,
                                  UserRole role,
                                  uint32_t expiredTs) {
  std::string str;
  if (uid != 0) {
    str = std::to_string(uid);
  }
  return SimpleTokenBuilder2::buildTokenWithUserAccount(appId,
                                   appCertificate,
                                   channelName,
                                   str,
                                   role,
                                   expiredTs);
}

std::string SimpleTokenBuilder2::buildTokenWithUserAccount(
                                          const std::string& appId,
                                          const std::string& appCertificate,
                                          const std::string& channelName,
                                          const std::string& userAccount,
                                          UserRole role,
                                          uint32_t expiredTs) {
  AccessToken generator(appId, appCertificate, channelName, userAccount);
  generator.AddPrivilege(AccessToken::Privileges::kJoinChannel,
                         expiredTs);
  if (role == Role_Attendee || role == Role_Publisher || role == Role_Admin) {
    generator.AddPrivilege(AccessToken::Privileges::kPublishAudioStream,
                           expiredTs);
    generator.AddPrivilege(AccessToken::Privileges::kPublishVideoStream,
                           expiredTs);
    generator.AddPrivilege(AccessToken::Privileges::kPublishDataStream,
                           expiredTs);
  }
  return generator.Build();
}
}  // namespace tools
}  // namespace agora
