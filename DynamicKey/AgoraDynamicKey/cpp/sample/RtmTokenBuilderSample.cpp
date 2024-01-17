/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ RtmTokenBuilderSample.cpp  -lz -lcrypto -o RtmTokenBuilderSample
 */
#include "../src/RtmTokenBuilder.h"
#include <iostream>
#include <cstdint>
#include <cstdlib>

using namespace agora::tools;

int main(int argc, char const *argv[])
{
  // Need to set environment variable AGORA_APP_ID
  const char *envAppId = getenv("AGORA_APP_ID");
  std::string appId = envAppId ? envAppId : "";
  // Need to set environment variable AGORA_APP_CERTIFICATE
  const char *envAppCertificate = getenv("AGORA_APP_CERTIFICATE");
  std::string appCertificate = envAppCertificate ? envAppCertificate : "";

  std::string user = "test_user_id";
  uint32_t expirationTimeInSeconds = 3600;
  uint32_t currentTimeStamp = time(NULL);
  uint32_t privilegeExpiredTs = currentTimeStamp + expirationTimeInSeconds;

  std::cout << "App Id:" << appId << std::endl;
  std::cout << "App Certificate:" << appCertificate << std::endl;
  if (appId == "" || appCertificate == "")
  {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  std::string result = RtmTokenBuilder::buildToken(appId, appCertificate, user, RtmUserRole::Rtm_User, privilegeExpiredTs);
  std::cout << "Rtm Token:" << result << std::endl;

  return 0;
}
