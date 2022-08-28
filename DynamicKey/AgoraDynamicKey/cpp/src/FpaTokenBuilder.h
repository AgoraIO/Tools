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
   @return The new Token. Token is available for 24 hours after generation
   */
   static std::string BuildToken(
       const std::string& app_id,
       const std::string& app_certificate);
};

inline std::string FpaTokenBuilder::BuildToken(
    const std::string& app_id, const std::string& app_certificate) {
  std::unique_ptr<Service> service(new ServiceFpa());
  service->AddPrivilege(ServiceFpa::kPrivilegeLogin, 0);

  AccessToken2 generator(app_id, app_certificate, 0, 24 * 3600);
  generator.AddService(std::move(service));

  return generator.Build();
}

}  // namespace tools
}  // namespace agora

