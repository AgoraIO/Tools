#include "../src/DynamicKey3.h"
#include <gtest/gtest.h>
#include <string>

class DynamicKey3_test : public testing::Test
{
protected:
    // Initializes the test fixture.
    virtual void SetUp(){}

    // Releases resources allocated by the test fixture.
    virtual void TearDown(){}

public:
    // Tests deterministic DynamicKey3 generation.
    void test_DynamicKey3();
};

// Verifies DynamicKey3 generation against the expected value.
void DynamicKey3_test::test_DynamicKey3(){
    auto AppID  = "970ca35de60c44645bbae8a215061b33";
    auto  AppCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
    auto channelName= "7d72365eb983485397e3e3f9d460bdda";
    auto  unixTs = 1446455472;
    auto  randomInt = 58964981;
    uint32_t uid=2882341273u;
    auto  expiredTs=1446455471;
    std::string result = agora::tools::DynamicKey3::generate(AppID, AppCertificate, channelName, unixTs, randomInt, uid, expiredTs);
    EXPECT_EQ(result, "0037666966591a93ee5a3f712e22633f31f0cbc8f13970ca35de60c44645bbae8a215061b3314464554720383bbf528823412731446455471");
}

// Tests deterministic DynamicKey3 generation.
TEST_F(DynamicKey3_test, test_DynamicKey3)
{
    test_DynamicKey3();
}
