#include "../src/DynamicKey4.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>

class DynamicKey4_test : public testing::Test
{
protected:
    virtual void SetUp(){}
    virtual void TearDown(){}

public:
    void test_MediaChannelKey4();

    void test_RecordingKey();

    void test_PublicSharingKey();
};

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

TEST_F(DynamicKey4_test, test_PublicSharingKey)
{
    test_PublicSharingKey();
}
TEST_F(DynamicKey4_test, test_RecordingKey)
{
    test_RecordingKey();
}
TEST_F(DynamicKey4_test, test_MediaChannelKey4)
{
    test_MediaChannelKey4();
}
