/**
 * build with command:
 * g++ -std=c++0x -O0 -I../../ sample_builder2.cpp  -lz -lcrypto -o sample_builder2
 */
#include "../src/SimpleTokenBuilder2.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {

  std::string appID  = "970CA35de60c44645bbae8a215061b33";
  std::string  appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
  std::string channelName= "7d72365eb983485397e3e3f9d460bdda";
  uint32_t uid = 2882341273;
  std::string userAccount = "2882341273";
  uint32_t expireTimestamp = 0;
  std::string result;
  result = SimpleTokenBuilder2::buildTokenWithUid(
      appID, appCertificate, channelName, uid, UserRole::Role_Attendee, expireTimestamp);
  std::cout << result << std::endl;
  result = SimpleTokenBuilder2::buildTokenWithUserAccount(
      appID, appCertificate, channelName, userAccount, UserRole::Role_Attendee, expireTimestamp);
  std::cout << result << std::endl;
  return 0;
}
