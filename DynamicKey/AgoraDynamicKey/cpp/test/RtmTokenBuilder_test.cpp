#include "../src/RtmTokenBuilder.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

class RtmTokenBuilder_test : public testing::Test {
 protected:
  // Initializes deterministic Token006 RTM fields and the expected user CRC.
  virtual void SetUp() {
    appID = "970CA35de60c44645bbae8a215061b33";
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    userAccount = "test_user";
    expiredTs = 1446455471;
    crcUserAccount = crc32(
        0, reinterpret_cast<Bytef*>(const_cast<char*>(userAccount.c_str())),
        userAccount.length());

  }

  // Releases resources allocated by the test fixture.
  virtual void TearDown() {}

  // Tests Token006 RTM generation, parsing, and signature validation.
  void testRtmTokenBuilder() {
      std::string token = RtmTokenBuilder::buildToken(
          appID, appCertificate, userAccount,
          RtmUserRole::Rtm_User, expiredTs);
      AccessToken parser;
      parser.FromString(token);
      EXPECT_EQ(parser.app_id_, appID);
      EXPECT_EQ(parser.crc_channel_name_ , crcUserAccount);
      EXPECT_EQ(parser.crc_uid_,
              crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>("")),
              0));
      EXPECT_EQ(parser.message_.messages[AccessToken::kRtmLogin], expiredTs);
      EXPECT_EQ(
          AccessToken::GenerateSignature(
            appCertificate, appID, userAccount,
            "", parser.message_raw_content_),
          parser.signature_);
  }

 private:
  std::string appID;
  std::string appCertificate;
  std::string userAccount;
  uint32_t expiredTs;
  uint32_t crcUserAccount;
};


// Tests Token006 RTM token generation.
TEST_F(RtmTokenBuilder_test, testRtmTokenBuilder) {
  testRtmTokenBuilder();
}
