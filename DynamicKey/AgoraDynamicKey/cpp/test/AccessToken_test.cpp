#include "../src/AccessToken.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

class AccessToken_test : public testing::Test {
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

  void testAccessToken(std::string expected, AccessToken key) {
    std::string result = key.Build();
    EXPECT_EQ(expected, result);

    if (expected == "") {
      return;
    }
    AccessToken k6;
    bool parsed = k6.FromString(result);
    ASSERT_TRUE(parsed);
    EXPECT_EQ(k6.app_id_, key.app_id_);
    EXPECT_EQ(k6.crc_channel_name_, key.crc_channel_name_);
    EXPECT_EQ(k6.crc_uid_, key.crc_uid_);
    uint32_t crc_channel_name = crc32(
        0,
        reinterpret_cast<Bytef*>(const_cast<char*>(key.channel_name_.c_str())),
        key.channel_name_.length());
    uint32_t crc_uid =
        crc32(0, reinterpret_cast<Bytef*>(const_cast<char*>(key.uid_.c_str())),
              key.uid_.length());

    EXPECT_EQ(k6.crc_channel_name_, crc_channel_name);
    EXPECT_EQ(k6.crc_uid_, crc_uid);
    EXPECT_EQ(k6.message_.ts, key.message_.ts);
    EXPECT_EQ(k6.message_.salt, key.message_.salt);
    EXPECT_EQ(k6.message_.messages[AccessToken::Privileges::kJoinChannel],
              key.message_.messages[AccessToken::Privileges::kJoinChannel]);

    std::string signature = AccessToken::GenerateSignature(
        appCertificate, k6.app_id_, key.channel_name_, key.uid_,
        k6.message_raw_content_);
    EXPECT_EQ(k6.signature_, signature);
  }
  void testAccessTokenWithIntUid() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+"
        "72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    AccessToken key(appID, appCertificate, channelName, uid);
    key.message_.salt = 1;
    key.message_.ts = 1111111;
    key.message_.messages[AccessToken::Privileges::kJoinChannel] = expiredTs;
    testAccessToken(expected, key);
  }

  void testAccessTokenWithIntUidZero() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IACw1o7htY6ISdNRtku3p9tjTPi0jCKf9t49UHJhzCmL6bdIfRAAAAAAEAABAAAAR/QQAAEAAQCvKDdW";
    uint32_t uid_zero = 0;
    AccessToken key(appID, appCertificate, channelName, uid_zero);
    key.message_.salt = 1;
    key.message_.ts = 1111111;
    key.message_.messages[AccessToken::Privileges::kJoinChannel] = expiredTs;
    testAccessToken(expected, key);
  }

  void testAccessTokenWithStringUid() {
    std::string expected =
        "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+"
        "72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
    AccessToken key( appID, appCertificate, channelName, uidStr);
    key.message_.salt = 1;
    key.message_.ts = 1111111;
    key.message_.messages[AccessToken::Privileges::kJoinChannel] = expiredTs;
    testAccessToken(expected, key);
  }

  void testAccessTokenWithErrorUid() {
    std::string expected = "";
    AccessToken key(appID, appCertificate, channelName, "error");
    key.message_.salt = 1;
    key.message_.ts = 1111111;
    key.AddPrivilege(AccessToken::Privileges::kJoinChannel, 100);
    testAccessToken(expected, key);
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

// TEST_F(AccessToken_test, testAccessTokenWithErrorUid) {
  // testAccessTokenWithErrorUid();
// }
TEST_F(AccessToken_test, testAccessTokenWithIntUid) {
  testAccessTokenWithIntUid();
}
TEST_F(AccessToken_test, testAccessTokenWithIntUidZero) {
  testAccessTokenWithIntUidZero();
}
TEST_F(AccessToken_test, testAccessTokenWithStringUid) {
  testAccessTokenWithStringUid();
}
