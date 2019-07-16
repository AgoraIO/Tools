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


class SimpleTokenBuilder {
 public:
   // appID: The App ID issued to you by Agora. Apply for a new App ID from 
   //        Agora Dashboard if it is missing from your kit. See Get an App ID.
   // appCertificate:	Certificate of the application that you registered in 
   //                  the Agora Dashboard. See Get an App Certificate.
   // channelName:Unique channel name for the AgoraRTC session in the string format
   // uid: User ID. A 32-bit unsigned integer with a value ranging from 
   //      1 to (232-1). optionalUid must be unique.
   // role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
   //       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
   // privilegeExpireTs: represented by the number of seconds elapsed since 
   //                    1/1/1970. If, for example, you want to access the
   //                    Agora Service within 10 minutes after the token is 
   //                    generated, set expireTimestamp as the current 
   //                    timestamp + 600 (seconds)./
   static std::string buildTokenWithUid(
       const std::string& appId,
       const std::string& appCertificate,
       const std::string& channelName,
       uint32_t uid,
       UserRole role,
       uint32_t privilegeExpiredTs = 0);
   // appID: The App ID issued to you by Agora. Apply for a new App ID from 
   //        Agora Dashboard if it is missing from your kit. See Get an App ID.
   // appCertificate:	Certificate of the application that you registered in 
   //                  the Agora Dashboard. See Get an App Certificate.
   // channelName:Unique channel name for the AgoraRTC session in the string format
   // userAccount: The user account. 
   // role: Role_Publisher = 1: A broadcaster (host) in a live-broadcast profile.
   //       Role_Subscriber = 2: (Default) A audience in a live-broadcast profile.
   // privilegeExpireTs: represented by the number of seconds elapsed since 
   //                    1/1/1970. If, for example, you want to access the
   //                    Agora Service within 10 minutes after the token is 
   //                    generated, set expireTimestamp as the current 
   // 
  static std::string buildTokenWithUserAccount(
      const std::string& appId,
      const std::string& appCertificate,
      const std::string& channelName,
      const std::string& userAccount,
      UserRole role,
      uint32_t privilegeExpiredTs = 0);
};

inline std::string SimpleTokenBuilder::buildTokenWithUid(
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
  return SimpleTokenBuilder::buildTokenWithUserAccount(appId,
                                   appCertificate,
                                   channelName,
                                   str,
                                   role,
                                   privilegeExpiredTs);
}

inline std::string SimpleTokenBuilder::buildTokenWithUserAccount(
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
