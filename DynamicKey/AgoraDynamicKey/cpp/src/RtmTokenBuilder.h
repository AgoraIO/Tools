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

enum RtmUserRole {
  Rtm_User = 1,
};

class RtmTokenBuilder {
 public:
  static std::string buildToken(const std::string& appId,
                                const std::string& appCertificate,
                                const std::string& userAccount,
                                RtmUserRole userRole,
                                uint32_t expiredTs);
};

inline std::string RtmTokenBuilder::buildToken(
    const std::string& appId, const std::string& appCertificate,
    const std::string& userAccount, RtmUserRole userRole, uint32_t expiredTs) {
  AccessToken generator(appId, appCertificate, userAccount, "");
  generator.AddPrivilege(AccessToken::Privileges::kRtmLogin, expiredTs);
  return generator.Build();
}
}  // namespace tools
}  // namespace agora
