/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ RtmTokenBuilderSample.cpp  -lz -lcrypto -o RtmTokenBuilderSample
 */
#include "../src/RtmTokenBuilder.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[])
{
  // Need to set environment variable AGORA_APP_ID
  std::string appID = getenv("AGORA_APP_ID");
  // Need to set environment variable AGORA_APP_CERTIFICATE
  std::string appCertificate = getenv("AGORA_APP_CERTIFICATE");

  std::string user = "test_user_id";
  uint32_t expirationTimeInSeconds = 3600;
  uint32_t currentTimeStamp = time(NULL);
  uint32_t privilegeExpiredTs = currentTimeStamp + expirationTimeInSeconds;

  std::string result =
      RtmTokenBuilder::buildToken(appID, appCertificate, user,
                                  RtmUserRole::Rtm_User, privilegeExpiredTs);
  std::cout << "Rtm Token:" << result << std::endl;

  return 0;
}
