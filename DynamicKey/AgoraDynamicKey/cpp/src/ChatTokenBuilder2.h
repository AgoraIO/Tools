// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/AccessToken2.h"

namespace agora {
namespace tools {

class ChatTokenBuilder2 {
 public:
  /**
   Builds an Chat User token. 

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param user_id The user's id, must be unique.
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @return The new Token.
   */
  static std::string BuildUserToken(const std::string& app_id,
                                    const std::string& app_certificate,
                                    const std::string& user_id,
                                    uint32_t expire = 0);

  /**
   Builds an Chat App token.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @return The new Token.
   */
  static std::string BuildAppToken(const std::string& app_id,
                                   const std::string& app_certificate,
                                   uint32_t expire = 0);
};

inline std::string ChatTokenBuilder2::BuildUserToken(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& user_id, uint32_t expire) {
  std::unique_ptr<Service> service(new ServiceChat(user_id));
  service->AddPrivilege(ServiceChat::kPrivilegeUser, expire);

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

inline std::string ChatTokenBuilder2::BuildAppToken(
    const std::string& app_id, const std::string& app_certificate,
    uint32_t expire) {
  std::unique_ptr<Service> service(new ServiceChat());
  service->AddPrivilege(ServiceChat::kPrivilegeApp, expire);

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

}  // namespace tools
}  // namespace agora
