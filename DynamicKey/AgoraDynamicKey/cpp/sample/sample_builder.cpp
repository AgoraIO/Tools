/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ sample_builder.cpp  -lz -lcrypto -lpthread -o sample_builder
 */
#include "../src/SimpleTokenBuilder.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {

  std::string appID  = "970CA35de60c44645bbae8a215061b33";
  std::string  appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
  std::string channelName= "7d72365eb983485397e3e3f9d460bdda";
  uint32_t uid = 2882341273;
  uint32_t expireTimestamp = 0;

  SimpleTokenBuilder builder(appID, appCertificate, channelName, uid);
  builder.initPrivileges(Role::Role_Attendee);
  builder.setPrivilege(AccessToken::Privileges::kJoinChannel, expireTimestamp);
  builder.setPrivilege(AccessToken::Privileges::kPublishAudioStream, expireTimestamp);
  builder.setPrivilege(AccessToken::Privileges::kPublishVideoStream, expireTimestamp);
  builder.setPrivilege(AccessToken::Privileges::kPublishDataStream, expireTimestamp);
  
  std::string result = builder.buildToken();
  std::cout << result << std::endl;

  return 0;
}
