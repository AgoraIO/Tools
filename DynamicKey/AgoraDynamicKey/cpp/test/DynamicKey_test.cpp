#include "../src/DynamicKey.h"
#include <gtest/gtest.h>
#include <string>

class DynamicKey_test : public testing::Test
{
protected:
    // Initializes the test fixture.
    virtual void SetUp(){}

    // Releases resources allocated by the test fixture.
    virtual void TearDown(){}

public:
    // Tests deterministic DynamicKey generation.
    void test_DynamicKey();
};

// Verifies DynamicKey generation against the expected value.
void DynamicKey_test::test_DynamicKey(){
    auto AppID  = "970ca35de60c44645bbae8a215061b33";
    auto  AppCertificate   = "5cfd2fd1755d40ecb72977518be15d3b";
    auto channelName= "7d72365eb983485397e3e3f9d460bdda";
    auto  unixTs = 1446455472;
    auto  randomInt = 58964981;
    std::string result = agora::tools::DynamicKey::generate(AppID, AppCertificate, channelName, unixTs, randomInt);
    EXPECT_EQ(result, "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5");
}

// Tests deterministic DynamicKey generation.
TEST_F(DynamicKey_test, test_DynamicKey)
{
    test_DynamicKey();
}
