#include "../src/RtmTokenBuilder.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

class RtmTokenBuilder_test : public testing::Test {
 protected:
  virtual void SetUp() {
    appID = "970CA35de60c44645bbae8a215061b33";
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    userId = "test_user";
    expiredTs = 1446455471;
  }

  virtual void TearDown() {}

  void testRtmTokenBuilder(std::string expected, RtmTokenBuilder orgbuilder) {
    std::string result = orgbuilder.buildToken();
    EXPECT_EQ(expected, result);

    if (expected == "") {
      return;
    }
    RtmTokenBuilder builder;
    bool parsed = builder.initTokenBuilder(result);
    ASSERT_TRUE(parsed);
    EXPECT_EQ(builder.m_tokenCreator.app_id_, orgbuilder.m_tokenCreator.app_id_);
    EXPECT_EQ(builder.m_tokenCreator.crc_channel_name_, orgbuilder.m_tokenCreator.crc_channel_name_);
    EXPECT_EQ(builder.m_tokenCreator.crc_uid_, orgbuilder.m_tokenCreator.crc_uid_);
    uint32_t crc_channel_name = crc32(
        0,
        reinterpret_cast<Bytef*>(const_cast<char*>(orgbuilder.m_tokenCreator.channel_name_.c_str())),
        orgbuilder.m_tokenCreator.channel_name_.length());
    uint32_t crc_uid =
        crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>(orgbuilder.m_tokenCreator.uid_.c_str())),
              orgbuilder.m_tokenCreator.uid_.length());

    EXPECT_EQ(builder.m_tokenCreator.crc_channel_name_, crc_channel_name);
    EXPECT_EQ(builder.m_tokenCreator.crc_uid_, crc_uid);
    EXPECT_EQ(builder.m_tokenCreator.message_.ts, orgbuilder.m_tokenCreator.message_.ts);
    EXPECT_EQ(builder.m_tokenCreator.message_.salt, orgbuilder.m_tokenCreator.message_.salt);
    EXPECT_EQ(builder.m_tokenCreator.message_.messages[AccessToken::Privileges::kRtmLogin],
              orgbuilder.m_tokenCreator.message_.messages[AccessToken::Privileges::kRtmLogin]);

    std::string signature = AccessToken::GenerateSignature(
        appCertificate, builder.m_tokenCreator.app_id_, orgbuilder.m_tokenCreator.channel_name_, orgbuilder.m_tokenCreator.uid_,
        builder.m_tokenCreator.message_raw_content_);
    EXPECT_EQ(builder.m_tokenCreator.signature_, signature);
  }
  void testRtmTokenBuilderWithDefalutPriviledge() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW";

    RtmTokenBuilder builder(appID, appCertificate, userId);
    builder.m_tokenCreator.message_.salt = 1;
    builder.m_tokenCreator.message_.ts = 1111111;
    builder.m_tokenCreator.AddPrivilege(AccessToken::Privileges::kRtmLogin, expiredTs);
    testRtmTokenBuilder(expected, builder);
  }

  void testRtmTokenBuilderWithLimitPriviledge() {
    std::string expected = "006970CA35de60c44645bbae8a215061b33IABR8ywaENKv6kia6iUU6P54g017Bi6Ym9sIGdt9f3sLLYb86ogAAAAAEAABAAAAR/QQAAEA6ANkAAAA";
    RtmTokenBuilder builder(appID, appCertificate, userId);
    builder.m_tokenCreator.message_.salt = 1;
    builder.m_tokenCreator.message_.ts = 1111111;
    builder.m_tokenCreator.AddPrivilege(AccessToken::Privileges::kRtmLogin, 100);
    testRtmTokenBuilder(expected, builder);
  }


 public:
 private:
  std::string appID;
  std::string appCertificate;
  std::string userId;
  uint32_t expiredTs;
};


TEST_F(RtmTokenBuilder_test, testRtmTokenBuilderWithDefalutPriviledge) {
  testRtmTokenBuilderWithDefalutPriviledge();
}

TEST_F(RtmTokenBuilder_test, testRtmTokenBuilderWithLimitPriviledge) {
  testRtmTokenBuilderWithLimitPriviledge();
}

