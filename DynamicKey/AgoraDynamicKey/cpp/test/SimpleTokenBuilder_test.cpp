#include "../src/SimpleTokenBuilder.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

class SimpleTokenBuilder_test : public testing::Test {
 protected:
  virtual void SetUp() {
    appID = "970CA35de60c44645bbae8a215061b33";
    appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    channelName = "7d72365eb983485397e3e3f9d460bdda";
    uid = 2882341273u;
    uidStr = "2882341273";
    expiredTs = 1446455471;
  }

  virtual void TearDown() {}

  void testSimpleTokenBuilder(std::string expected, SimpleTokenBuilder orgbuilder) {
    std::string result = orgbuilder.buildToken();
    EXPECT_EQ(expected, result);

    if (expected == "") {
      return;
    }
    SimpleTokenBuilder builder;
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
    EXPECT_EQ(builder.m_tokenCreator.message_.messages[AccessToken::Privileges::kJoinChannel],
              orgbuilder.m_tokenCreator.message_.messages[AccessToken::Privileges::kJoinChannel]);

    std::string signature = AccessToken::GenerateSignature(
        appCertificate, builder.m_tokenCreator.app_id_, orgbuilder.m_tokenCreator.channel_name_, orgbuilder.m_tokenCreator.uid_,
        builder.m_tokenCreator.message_raw_content_);
    EXPECT_EQ(builder.m_tokenCreator.signature_, signature);
  }
  void testSimpleTokenBuilderWithIntUid() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    SimpleTokenBuilder builder(appID, appCertificate, channelName, uid);
    builder.m_tokenCreator.message_.salt = 1;
    builder.m_tokenCreator.message_.ts = 1111111;
    // builder.m_tokenCreator.AddPrivilege(AccessToken::Privileges::kJoinChannel, expiredTs);
    builder.m_tokenCreator.message_.messages[AccessToken::Privileges::kJoinChannel] = expiredTs;
    testSimpleTokenBuilder(expected, builder);
  }

  void testSimpleTokenBuilderWithStringUid() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    SimpleTokenBuilder builder(
            appID, appCertificate, channelName, uidStr);
    // builder.m_tokenCreator.AddPrivilege(AccessToken::Privileges::kJoinChannel, expiredTs);
    builder.m_tokenCreator.message_.messages[AccessToken::Privileges::kJoinChannel] = expiredTs;
    builder.m_tokenCreator.message_.salt = 1;
    builder.m_tokenCreator.message_.ts = 1111111;
    testSimpleTokenBuilder(expected, builder);
  }

  void testSimpleTokenBuilderWithErrorUid() {
    std::string expected = "";
    SimpleTokenBuilder builder(appID, appCertificate, channelName, "error");
    builder.m_tokenCreator.message_.salt = 1;
    builder.m_tokenCreator.message_.ts = 1111111;
    builder.m_tokenCreator.AddPrivilege(AccessToken::Privileges::kJoinChannel, 100);
    testSimpleTokenBuilder(expected, builder);
  }

 public:
 private:
  std::string appID;
  std::string appCertificate;
  std::string channelName;
  uint32_t uid;
  std::string uidStr;
  uint32_t expiredTs;
};

TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithErrorUid) {
  testSimpleTokenBuilderWithErrorUid();
}
TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithIntUid) {
  testSimpleTokenBuilderWithIntUid();
}
TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithStringUid) {
  testSimpleTokenBuilderWithStringUid();
}
