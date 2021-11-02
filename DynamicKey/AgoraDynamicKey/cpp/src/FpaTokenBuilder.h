// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <zlib.h>

#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include <utility>

#include "cpp/src/AccessToken2.h"

namespace agora {
namespace tools {

class FpaTokenBuilder {
 public:
  /**
   Builds a FPA token.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param token_expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora FPA Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @param privilege_expire Reserved Field. 
   @return The new Token.
   */
   static std::string BuildToken(
       const std::string& app_id,
       const std::string& app_certificate,
       uint32_t token_expire = 3600,
       uint32_t privilege_expire = 0);
};

inline std::string FpaTokenBuilder::BuildToken(
    const std::string& app_id, const std::string& app_certificate,
    uint32_t token_expire, uint32_t privilege_expire) {
  std::unique_ptr<Service> service(new ServiceFpa());
  service->AddPrivilege(ServiceFpa::kPrivilegeLogin, privilege_expire);

  AccessToken2 generator(app_id, app_certificate, 0, token_expire);
  generator.AddService(std::move(service));

  return generator.Build();

}

}  // namespace tools
}  // namespace agora

