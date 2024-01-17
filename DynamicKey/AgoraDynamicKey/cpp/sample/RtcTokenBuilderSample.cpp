/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ RtcTokenBuilderSample.cpp  -lz -lcrypto -o
 * RtcTokenBuilderSample
 */
#include "../src/RtcTokenBuilder.h"
#include <cstdint>
#include <cstdlib>
#include <iostream>

using namespace agora::tools;

int main(int argc, char const *argv[]) {
  // Need to set environment variable AGORA_APP_ID
  const char *envAppId = getenv("AGORA_APP_ID");
  std::string appId = envAppId ? envAppId : "";
  // Need to set environment variable AGORA_APP_CERTIFICATE
  const char *envAppCertificate = getenv("AGORA_APP_CERTIFICATE");
  std::string appCertificate = envAppCertificate ? envAppCertificate : "";

  std::string channelName = "7d72365eb983485397e3e3f9d460bdda";
  uint32_t uid = 2882341273;
  std::string userAccount = "2882341273";
  uint32_t expirationTimeInSeconds = 3600;
  uint32_t currentTimeStamp = time(NULL);
  uint32_t privilegeExpiredTs = currentTimeStamp + expirationTimeInSeconds;
  std::string result;

  std::cout << "App Id:" << appId << std::endl;
  std::cout << "App Certificate:" << appCertificate << std::endl;
  if (appId == "" || appCertificate == "") {
    std::cout << "Need to set environment variable AGORA_APP_ID and "
                 "AGORA_APP_CERTIFICATE"
              << std::endl;
    return -1;
  }

  result = RtcTokenBuilder::buildTokenWithUid(
      appId, appCertificate, channelName, uid, UserRole::Role_Publisher,
      privilegeExpiredTs);
  std::cout << "Token With Int Uid:" << result << std::endl;

  result = RtcTokenBuilder::buildTokenWithUserAccount(
      appId, appCertificate, channelName, userAccount, UserRole::Role_Publisher,
      privilegeExpiredTs);
  std::cout << "Token With UserAccount:" << result << std::endl;

  return 0;
}
