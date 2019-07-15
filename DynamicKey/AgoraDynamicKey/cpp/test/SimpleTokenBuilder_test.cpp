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
    crc_channel_name  = crc32(
        0, reinterpret_cast<Bytef*>(const_cast<char*>(channelName.c_str())),
        channelName.length());
    crc_uid =
        crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>(uidStr.c_str())),
              uidStr.length());
    
  }

  virtual void TearDown() {}

  void testSimpleTokenBuilderWithIntUid() {
    {
      std::string token = SimpleTokenBuilder::buildTokenWithUid(
          appID, appCertificate, channelName, uid,
          UserRole::Role_Subscriber, expiredTs);
      AccessToken parser;
      parser.FromString(token);
      EXPECT_EQ(parser.app_id_, appID);
      EXPECT_EQ(parser.crc_channel_name_ , crc_channel_name);
      EXPECT_EQ(parser.crc_uid_, crc_uid);
      EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expiredTs);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream], 0);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream], 0);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream], 0);
      EXPECT_EQ(
          AccessToken::GenerateSignature(
            appCertificate, appID, channelName,
            std::to_string(uid), parser.message_raw_content_),
          parser.signature_);
    }
    {
      std::string token = SimpleTokenBuilder::buildTokenWithUid(
          appID, appCertificate, channelName, uid,
          UserRole::Role_Attendee, expiredTs);
      AccessToken parser;
      parser.FromString(token);
      EXPECT_EQ(parser.app_id_, appID);
      EXPECT_EQ(parser.crc_channel_name_ , crc_channel_name);
      EXPECT_EQ(parser.crc_uid_, crc_uid);
      EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expiredTs);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream], expiredTs);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream], expiredTs);
      EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream], expiredTs);
      EXPECT_EQ(
          AccessToken::GenerateSignature(
            appCertificate, appID, channelName,
            std::to_string(uid), parser.message_raw_content_),
          parser.signature_);
    }
  }

  void testSimpleTokenBuilderWithZero() {
    std::string token = SimpleTokenBuilder::buildTokenWithUid(
        appID, appCertificate, channelName, 0,
        UserRole::Role_Attendee, expiredTs);
    AccessToken parser;
    parser.FromString(token);
    EXPECT_EQ(parser.app_id_, appID);
    EXPECT_EQ(parser.crc_channel_name_ , crc_channel_name);
    EXPECT_EQ(parser.crc_uid_,
              crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>("")),
              0));
    EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream], expiredTs);
    EXPECT_EQ(
        AccessToken::GenerateSignature(
          appCertificate, appID, channelName,
          "", parser.message_raw_content_),
        parser.signature_);
  }


  void testSimpleTokenBuilderWithStringUid() {
    {
    std::string token = SimpleTokenBuilder::buildTokenWithUserAccount(
        appID, appCertificate, channelName, uidStr,
        UserRole::Role_Subscriber, expiredTs);
    AccessToken parser;
    parser.FromString(token);
    EXPECT_EQ(parser.app_id_, appID);
    EXPECT_EQ(parser.crc_channel_name_ , crc_channel_name);
    EXPECT_EQ(parser.crc_uid_, crc_uid);
    EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream], 0);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream], 0);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream], 0);
    EXPECT_EQ(
        AccessToken::GenerateSignature(
          appCertificate, appID, channelName,
          uidStr, parser.message_raw_content_),
        parser.signature_);
    }
    {
    std::string token = SimpleTokenBuilder::buildTokenWithUserAccount(
        appID, appCertificate, channelName, uidStr,
        UserRole::Role_Attendee, expiredTs);
    AccessToken parser;
    parser.FromString(token);
    EXPECT_EQ(parser.app_id_, appID);
    EXPECT_EQ(parser.crc_channel_name_ , crc_channel_name);
    EXPECT_EQ(parser.crc_uid_, crc_uid);
    EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream], expiredTs);
    EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream], expiredTs);
    EXPECT_EQ(
        AccessToken::GenerateSignature(
          appCertificate, appID, channelName,
          uidStr, parser.message_raw_content_),
        parser.signature_);
    }
  }

 private:
  std::string appID;
  std::string appCertificate;
  std::string channelName;
  uint32_t uid;
  std::string uidStr;
  uint32_t expiredTs;
  uint32_t crc_channel_name;
  uint32_t crc_uid;
};

TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithZero) {
  testSimpleTokenBuilderWithZero();
}

TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithIntUid) {
  testSimpleTokenBuilderWithIntUid();
}

TEST_F(SimpleTokenBuilder_test, testSimpleTokenBuilderWithStringUid) {
  testSimpleTokenBuilderWithStringUid();
}
