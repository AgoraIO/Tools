#include "../src/DynamicKey5.h"
#include <gtest/gtest.h>
#include <string>
#include <stdint.h>
using namespace agora::tools;

std::string appID;
std::string appCertificate;
std::string channelName;
uint32_t unixTs;
uint32_t randomInt;
uint32_t uid;
uint32_t expiredTs;

class DynamicKey5_test : public testing::Test
{
protected:
    // Initializes deterministic DynamicKey5 fields shared by the test cases.
    virtual void SetUp()
    {
        appID  = "970CA35de60c44645bbae8a215061b33";
        appCertificate   = "5CFd2fd1755d40ecb72977518be15d3b";
        channelName= "7d72365eb983485397e3e3f9d460bdda";
        unixTs = 1446455472;
        randomInt = 58964981;
        uid=2882341273u;
        expiredTs=1446455471;
    }
    // Releases resources allocated by the test fixture.
    virtual void TearDown(){}

public:
    // Tests Media Channel Key generation and parsing.
    void test_MediaChannelKey();

    // Tests Recording Key generation and parsing.
    void test_RecordingKey();

    // Tests Public Sharing Key generation and parsing.
    void test_PublicSharingKey();

    // Tests in-channel permission key generation and parsing.
    void test_InChannelPermission();

private:
    // Verifies an in-channel permission value against its expected encoding.
    void test_InChannelPermission(const std::string& x, const std::string& expected);
};

// Verifies deterministic DynamicKey5 generation, parsing, and signatures.
template<typename Generate, typename Verify>
void testDynamicKey(const std::string& expected, DynamicKey5::ServiceType service, Generate g, Verify v)
{
    std::string result = g();

    EXPECT_EQ(expected, result);

    DynamicKey5 k5;
    bool parsed = k5.fromString(result);
    ASSERT_TRUE(parsed);

    EXPECT_EQ(k5.appID, toupper(appID));
    EXPECT_EQ(k5.unixTs, unixTs);
    EXPECT_EQ(k5.randomInt, randomInt);
    EXPECT_EQ(k5.expiredTs, expiredTs);

    std::string signature = DynamicKey5::generateSignature(
                                    appCertificate
                                    , service
                                    , k5.appID
                                    , k5.unixTs
                                    , k5.randomInt
                                    , channelName
                                    , uid
                                    , k5.expiredTs
                                    , k5.extra);
    EXPECT_EQ(k5.signature, signature);
    v(k5);
}

// Verifies Public Sharing Key generation and parsing.
void DynamicKey5_test::test_PublicSharingKey(){
    auto expected = "005AwAoADc0QTk5RTVEQjI4MDk0NUI0NzUwNTk0MUFDMjM4MDU2NzIwREY3QjAQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";

    testDynamicKey(expected, DynamicKey5::PUBLIC_SHARING_SERVICE, []() {
        return DynamicKey5::generatePublicSharingKey(
                    appID
                    , appCertificate
                    , channelName
                    , unixTs
                    , randomInt
                    , uid
                    , expiredTs);
    }, [](const DynamicKey5& k5) {});
}

// Verifies Recording Key generation and parsing.
void DynamicKey5_test::test_RecordingKey(){
    auto expected = "005AgAoADkyOUM5RTQ2MTg3QTAyMkJBQUIyNkI3QkYwMTg0MzhDNjc1Q0ZFMUEQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";

    testDynamicKey(expected, DynamicKey5::RECORDING_SERVICE, []() {
        return DynamicKey5::generateRecordingKey(
                    appID
                    , appCertificate
                    , channelName
                    , unixTs
                    , randomInt
                    , uid
                    , expiredTs);
    }, [](const DynamicKey5& k5) {});
}

// Verifies Media Channel Key generation and parsing.
void DynamicKey5_test::test_MediaChannelKey(){
    auto expected = "005AQAoAEJERTJDRDdFNkZDNkU0ODYxNkYxQTYwOUVFNTM1M0U5ODNCQjFDNDQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YAAA==";

    testDynamicKey(expected, DynamicKey5::MEDIA_CHANNEL_SERVICE, []() {
        return DynamicKey5::generateMediaChannelKey(
                    appID
                    , appCertificate
                    , channelName
                    , unixTs
                    , randomInt
                    , uid
                    , expiredTs);
    }, [](const DynamicKey5& k5) {});
}

// Verifies supported in-channel upload permission encodings.
void DynamicKey5_test::test_InChannelPermission()
{
    auto noUpload = "005BAAoADgyNEQxNDE4M0FGRDkyOEQ4REFFMUU1OTg5NTg2MzA3MTEyNjRGNzQQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAw";
    testDynamicKey(noUpload, DynamicKey5::IN_CHANNEL_PERMISSION, []() {
        return DynamicKey5::generateInChannelPermissionKey(
                    appID
                    , appCertificate
                    , channelName
                    , unixTs
                    , randomInt
                    , uid
                    , expiredTs
                    , DynamicKey5::noUpload());
    }, [](DynamicKey5& k5) {
        ASSERT_FALSE(k5.extra.empty());
        EXPECT_TRUE(k5.extra.find(DynamicKey5::ALLOW_UPLOAD_IN_CHANNEL) != k5.extra.end());
        EXPECT_EQ(k5.extra[DynamicKey5::ALLOW_UPLOAD_IN_CHANNEL], DynamicKey5::noUpload());
    });

    auto audioVideoUpload = "005BAAoADJERDA3QThENTE2NzJGNjQwMzY5NTFBNzE0QkI5NTc0N0Q1QjZGQjMQAJcMo13mDERkW7roohUGGzOwKDdW9buDA68oN1YBAAEAAQAz";
    testDynamicKey(audioVideoUpload, DynamicKey5::IN_CHANNEL_PERMISSION, []() {
        return DynamicKey5::generateInChannelPermissionKey(
                    appID
                    , appCertificate
                    , channelName
                    , unixTs
                    , randomInt
                    , uid
                    , expiredTs
                    , DynamicKey5::audioVideoUpload());
    }, [](DynamicKey5& k5) {
        ASSERT_FALSE(k5.extra.empty());
        EXPECT_TRUE(k5.extra.find(DynamicKey5::ALLOW_UPLOAD_IN_CHANNEL) != k5.extra.end());
        EXPECT_EQ(k5.extra[DynamicKey5::ALLOW_UPLOAD_IN_CHANNEL], DynamicKey5::audioVideoUpload());
    });
}

// Tests Public Sharing Key generation and parsing.
TEST_F(DynamicKey5_test, test_PublicSharingKey)
{
    test_PublicSharingKey();
}

// Tests Recording Key generation and parsing.
TEST_F(DynamicKey5_test, test_RecordingKey)
{
    test_RecordingKey();
}

// Tests Media Channel Key generation and parsing.
TEST_F(DynamicKey5_test, test_MediaChannelKey)
{
    test_MediaChannelKey();
}

// Tests in-channel permission key generation and parsing.
TEST_F(DynamicKey5_test, test_InChannelPermission)
{
    test_InChannelPermission();
}
