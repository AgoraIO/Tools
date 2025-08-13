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
   token is generated, set expire as 600(seconds).
   @return The new Token.
   */
  static std::string BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& user_id, uint32_t expire = 0);
  /**
   Builds an RTM token.

   @attention This is a special interface that requires Agora assistance for proper 
   usage. Please seek help from Agora before using this interface to avoid unknown 
   errors in your application.
 
   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param user_id The user's account, max length is 64 Bytes.
   @param permissions Specify the permissions
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expire as 600(seconds).
   @return The new Token.
   */
  static std::string BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& user_id,
      const ServiceRtm2::Permissions &permissions, uint32_t expire = 0);

};

inline std::string RtmTokenBuilder2::BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& user_id, uint32_t expire) {
  std::unique_ptr<Service> service(new ServiceRtm(user_id));
  service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire);

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

inline std::string RtmTokenBuilder2::BuildToken(const std::string& app_id, const std::string& app_certificate,
    const std::string& user_id, const ServiceRtm2::Permissions &permissions,
    uint32_t expire) {
  std::unique_ptr<Service> service(new ServiceRtm2(user_id, permissions));
  service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire);

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

}  // namespace tools
}  // namespace agora
