/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ RtmTokenBuilderSample.cpp  -lz -lcrypto -o RtmTokenBuilderSample
 */
#include "../src/RtmTokenBuilder.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {

  std::string appID  = "970CA35de60c44645bbae8a215061b33";
  std::string appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
  std::string user= "test_user_id";
  uint32_t expirationTimeInSeconds = 3600;
  uint32_t currentTimeStamp = time(NULL);
  uint32_t privilegeExpiredTs = currentTimeStamp + expirationTimeInSeconds;
  std::string result =
    RtmTokenBuilder::buildToken(appID, appCertificate, user,
        RtmUserRole::Rtm_User, privilegeExpiredTs);
  std::cout << "Rtm Token:" << result << std::endl;
  return 0;
}
