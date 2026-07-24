#include "../src/DynamicKey4.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>

class DynamicKey4_test : public testing::Test
{
protected:
    // Initializes the test fixture.
    virtual void SetUp(){}

    // Releases resources allocated by the test fixture.
    virtual void TearDown(){}

public:
    // Tests Media Channel Key generation.
    void test_MediaChannelKey4();

    // Tests Recording Key generation.
    void test_RecordingKey();

    // Tests Public Sharing Key generation.
    void test_PublicSharingKey();
};

// Verifies Public Sharing Key generation against the expected value.
void DynamicKey4_test::test_PublicSharingKey(){
    auto AppID  = "970ca35de60c44645bbae8a215061b33";
    auto  AppCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
    auto channelName= "7d72365eb983485397e3e3f9d460bdda";
    auto  unixTs = 1446455472;
    auto  randomInt = 58964981;
    uint32_t uid=2882341273u;
    auto  expiredTs=1446455471;
    std::string result = agora::tools::DynamicKey4::generatePublicSharingKey(AppID, AppCertificate, channelName, unixTs, randomInt, uid, expiredTs);
    EXPECT_EQ(result, "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471");
}

// Verifies Recording Key generation against the expected value.
void DynamicKey4_test::test_RecordingKey(){
    auto AppID  = "970ca35de60c44645bbae8a215061b33";
    auto  AppCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
    auto channelName= "7d72365eb983485397e3e3f9d460bdda";
    auto  unixTs = 1446455472;
    auto  randomInt = 58964981;
    uint32_t uid=2882341273u;
    auto  expiredTs=1446455471;
    std::string result = agora::tools::DynamicKey4::generateRecordingKey(AppID, AppCertificate, channelName, unixTs, randomInt, uid, expiredTs);
    EXPECT_EQ(result, "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471");
}

// Verifies Media Channel Key generation against the expected value.
void DynamicKey4_test::test_MediaChannelKey4(){
    auto AppID  = "970ca35de60c44645bbae8a215061b33";
    auto  AppCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
    auto channelName= "7d72365eb983485397e3e3f9d460bdda";
    auto  unixTs = 1446455472;
    auto  randomInt = 58964981;
    uint32_t uid=2882341273u;
    auto  expiredTs=1446455471;
    std::string result = agora::tools::DynamicKey4::generateMediaChannelKey(AppID, AppCertificate, channelName, unixTs, randomInt, uid, expiredTs);
    EXPECT_EQ(result, "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471");
}

// Tests Public Sharing Key generation.
TEST_F(DynamicKey4_test, test_PublicSharingKey)
{
    test_PublicSharingKey();
}
// Tests Recording Key generation.
TEST_F(DynamicKey4_test, test_RecordingKey)
{
    test_RecordingKey();
}
// Tests Media Channel Key generation.
TEST_F(DynamicKey4_test, test_MediaChannelKey4)
{
    test_MediaChannelKey4();
}
