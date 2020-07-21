// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/AccessToken2.h"

namespace agora {
namespace tools {

enum class UserRole {
  /**
   RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
   your scenario does not require authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   */
  kRolePublisher = 1,
  /**
   Only use this role if your scenario require authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).

   @note In order for this role to take effect, please contact our support team
   to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   */
  kRoleSubscriber = 2,
};

class RtcTokenBuilder2 {
 public:
  /**
   Builds an RTC token using an int uid.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param channel_name The unique channel name for the AgoraRTC session in the
   string format. The string length must be less than 64 bytes. Supported
   character scopes are:
   - The 26 lowercase English letters: a to z.
   - The 26 uppercase English letters: A to Z.
   - The 10 digits: 0 to 9.
   - The space.
   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">",
   "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   @param uid User ID. A 32-bit unsigned integer with a value ranging from 1 to
   (2^32-1).
   @param role See #userRole.
   - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a
   live broadcast.
   - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario
   requires authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   In order for this role to take effect, please contact our support team to
   enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @return The new Token.
   */
  static std::string BuildTokenWithUid(const std::string& app_id,
                                       const std::string& app_certificate,
                                       const std::string& channel_name,
                                       uint32_t uid, UserRole role,
                                       uint32_t expire = 0);

  /**
   Builds an RTC token using a string userAccount.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param channel_name Unique channel name for the AgoraRTC session in the
   string format. The string length must be less than 64 bytes. Supported
   character scopes are:
   - The 26 lowercase English letters: a to z.
   - The 26 uppercase English letters: A to Z.
   - The 10 digits: 0 to 9.
   - The space.
   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">",
   "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   @param user_account The user account.
   @param role See #userRole.
   - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a
   live broadcast.
   - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario
   requires authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   In order for this role to take effect, please contact our support team to
   enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   @param expire represented by the number of seconds elapsed since now. If, for
   example, you want to access the Agora Service within 10 minutes after the
   token is generated, set expireTimestamp as 600(seconds).
   @return The new Token.
   */
  static std::string BuildTokenWithUserAccount(
      const std::string& app_id, const std::string& app_certificate,
      const std::string& channel_name, const std::string& user_account,
      UserRole role, uint32_t expire = 0);
};

inline std::string RtcTokenBuilder2::BuildTokenWithUid(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& channel_name, uint32_t uid, UserRole role,
    uint32_t expire) {
  std::string account;
  if (uid != 0) {
    account = std::to_string(uid);
  }
  return RtcTokenBuilder2::BuildTokenWithUserAccount(
      app_id, app_certificate, channel_name, account, role, expire);
}

inline std::string RtcTokenBuilder2::BuildTokenWithUserAccount(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& channel_name, const std::string& user_account,
    UserRole role, uint32_t expire) {
  std::unique_ptr<Service> service(
      new ServiceRtc(channel_name, user_account));
  service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire);
  if (role == UserRole::kRolePublisher) {
    service->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, expire);
    service->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, expire);
    service->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, expire);
  }

  AccessToken2 generator(app_id, app_certificate, 0, expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

}  // namespace tools
}  // namespace agora
