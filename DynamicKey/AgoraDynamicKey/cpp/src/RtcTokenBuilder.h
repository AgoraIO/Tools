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
    
  /**
   DEPRECATED. Role_Attendee has the same privileges as Role_Publisher.
   */
  Role_Attendee = 0,
  
  /**
   RECOMMENDED. Use this role for a voice/video call or a live broadcast, if your scenario does not require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   */
  Role_Publisher = 1,
  /**
   Only use this role if your scenario require authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   
   @note In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
   */
  Role_Subscriber = 2,
  /**
   DEPRECATED. Role_Admin has the same privileges as Role_Publisher.
   */
  Role_Admin = 101,
};


class RtcTokenBuilder {
 public:
    
   /**
    Builds an RTC token using an int uid.

    @param appId The App ID issued to you by Agora.
    @param appCertificate Certificate of the application that you registered in the Agora Dashboard.
    @param channelName The unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
    - The 26 lowercase English letters: a to z.
    - The 26 uppercase English letters: A to Z.
    - The 10 digits: 0 to 9.
    - The space.
    - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
    @param uid User ID. A 32-bit unsigned integer with a value ranging from 1 to (2^32-1).
    @param role See #userRole.
    - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a live broadcast.
    - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
    @param privilegeExpiredTs represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
    @return The new Token.
    */
   static std::string buildTokenWithUid(
       const std::string& appId,
       const std::string& appCertificate,
       const std::string& channelName,
       uint32_t uid,
       UserRole role,
       uint32_t privilegeExpiredTs = 0);
  
  /**
   Builds an RTC token using a string userAccount.

   @param appId The App ID issued to you by Agora.
   @param appCertificate Certificate of the application that you registered in the Agora Dashboard.
   @param channelName Unique channel name for the AgoraRTC session in the string format. The string length must be less than 64 bytes. Supported character scopes are:
   - The 26 lowercase English letters: a to z.
   - The 26 uppercase English letters: A to Z.
   - The 10 digits: 0 to 9.
   - The space.
   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   @param userAccount The user account.
   @param role See #userRole.
   - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a live broadcast.
   - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario requires authentication for [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in). In order for this role to take effect, please contact our support team to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber still has the same privileges as Role_Publisher.
   @param privilegeExpiredTs represented by the number of seconds elapsed since 1/1/1970. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set expireTimestamp as the current timestamp + 600 (seconds).
   @return The new Token.
   */
  static std::string buildTokenWithUserAccount(
      const std::string& appId,
      const std::string& appCertificate,
      const std::string& channelName,
      const std::string& userAccount,
      UserRole role,
      uint32_t privilegeExpiredTs = 0);
};

inline std::string RtcTokenBuilder::buildTokenWithUid(
                                  const std::string& appId,
                                  const std::string& appCertificate,
                                  const std::string& channelName,
                                  uint32_t uid,
                                  UserRole role,
                                  uint32_t privilegeExpiredTs) {
  std::string str;
  if (uid != 0) {
    str = std::to_string(uid);
  }
  return RtcTokenBuilder::buildTokenWithUserAccount(appId,
                                   appCertificate,
                                   channelName,
                                   str,
                                   role,
                                   privilegeExpiredTs);
}

inline std::string RtcTokenBuilder::buildTokenWithUserAccount(
                                          const std::string& appId,
                                          const std::string& appCertificate,
                                          const std::string& channelName,
                                          const std::string& userAccount,
                                          UserRole role,
                                          uint32_t privilegeExpiredTs) {
  AccessToken generator(appId, appCertificate, channelName, userAccount);
  generator.AddPrivilege(AccessToken::Privileges::kJoinChannel,
                         privilegeExpiredTs);
  if (role == Role_Attendee || role == Role_Publisher || role == Role_Admin) {
    generator.AddPrivilege(AccessToken::Privileges::kPublishAudioStream,
                           privilegeExpiredTs);
    generator.AddPrivilege(AccessToken::Privileges::kPublishVideoStream,
                           privilegeExpiredTs);
    generator.AddPrivilege(AccessToken::Privileges::kPublishDataStream,
                           privilegeExpiredTs);
  }
  return generator.Build();
}
}  // namespace tools
}  // namespace agora
