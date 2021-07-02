#include "../src/DynamicKey3.h"
#include <gtest/gtest.h>
#include <string>

class DynamicKey3_test : public testing::Test
{
protected:
    virtual void SetUp(){}
    virtual void TearDown(){}

public:
    void test_DynamicKey3();
};

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

TEST_F(DynamicKey3_test, test_DynamicKey3)
{
    test_DynamicKey3();
}
