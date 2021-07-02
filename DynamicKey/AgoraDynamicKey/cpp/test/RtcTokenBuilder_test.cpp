#include "../src/RtcTokenBuilder.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

class RtcTokenBuilder_test : public testing::Test {
 protected:
  virtual void SetUp() {
    appID = "970CA35de60c44645bbae8a215061b33";
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    userAccount = "test_user";
    crcUserAccount = crc32(
        0, reinterpret_cast<Bytef*>(const_cast<char*>(userAccount.c_str())),
        userAccount.length());
    cname = "7d72365eb983485397e3e3f9d460bdda";
    crcCname = crc32(
        0, reinterpret_cast<Bytef*>(const_cast<char*>(cname.c_str())),
        cname.length());

  }
  void testRtcTokenBuilder();
  virtual void TearDown() {}


 private:
  std::string appID;
  std::string appCertificate;
  std::string userAccount;
  uint32_t crcUserAccount;
  std::string cname;
  uint32_t crcCname;
};

 private:
  std::string app_id_;
  std::string app_cert_;
  std::string channel_name_;
  std::string account_;

}
