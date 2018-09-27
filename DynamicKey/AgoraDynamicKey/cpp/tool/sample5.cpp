/**
 * build with command:
 * g++ sample5.cpp  -lcrypto -std=c++0x
 */
#include "../src/DynamicKey5.h"
#include <iostream>
#include <cstdint>
using namespace agora::tools;

int main(int argc, char const *argv[]) {
  ::srand(::time(NULL));

  auto appID  = "970ca35de60c44645bbae8a215061b33";
  auto  appCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
  auto channelName= "my channel name for recording";
  auto  unixTs = ::time(NULL);
  int randomInt = (::rand()%256 << 24) + (::rand()%256 << 16) + (::rand()%256 << 8) + (::rand()%256);
  uint32_t uid = 2882341273u;
  auto  expiredTs = 0;

  std::cout << std::endl;
  std::cout << DynamicKey5::generateMediaChannelKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) << std::endl;
  std::cout << DynamicKey5::generateRecordingKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs) << std::endl;
  std::cout << DynamicKey5::generateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, DynamicKey5::noUpload()) << std::endl;
  std::cout << DynamicKey5::generateInChannelPermissionKey(appID, appCertificate, channelName, unixTs, randomInt, uid, expiredTs, DynamicKey5::audioVideoUpload()) << std::endl;

  return 0;
}
