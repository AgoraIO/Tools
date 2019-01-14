/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ rtm_builder.cpp  -lz -lcrypto -lpthread -o rtm_builder
 */
#include "../src/RtmTokenBuilder.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {

  std::string appID  = "970CA35de60c44645bbae8a215061b33";
  std::string appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
  std::string user= "test_user_id";
  uint32_t expireTimestamp = 0;

  RtmTokenBuilder builder(appID, appCertificate, user);
  builder.setPrivilege(AccessToken::Privileges::kRtmLogin, expireTimestamp);

  std::string result = builder.buildToken();
  std::cout << result << std::endl;

  return 0;
}
