// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/AccessToken2.h"

namespace agora {
namespace tools {

class RtmTokenBuilder2 {
 public:
  /**
   Builds an RTM token.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param user_id The user's account, max length is 64 Bytes.
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @return The new Token.
   */
  static std::string BuildToken(const std::string& app_id,
                                const std::string& app_certificate,
                                const std::string& user_id,
                                uint32_t expire = 0);
};

inline std::string RtmTokenBuilder2::BuildToken(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& user_id, uint32_t expire) {
  std::unique_ptr<Service> service(new ServiceRtm(user_id));
  service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire);

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

}  // namespace tools
}  // namespace agora
