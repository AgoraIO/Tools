// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/RtcTokenBuilder2.h"

#include <gtest/gtest.h>

#include <string>

#include "../src/AccessToken2.h"

using namespace agora::tools;

class RtcTokenBuilder2_test : public testing::Test
{
protected:
    virtual void SetUp() override
    {
        app_id_ = "970CA35de60c44645bbae8a215061b33";
        app_cert_ = "5CFd2fd1755d40ecb72977518be15d3b";
        channel_name_ = "7d72365eb983485397e3e3f9d460bdda";

        uid_ = 2882341273;
        expire_ = 1446455471;

        account_ = std::to_string(uid_);
    }

    void TestRtcTokenBuilderWithUid()
    {
        std::string token = RtcTokenBuilder2::BuildTokenWithUid(
            app_id_, app_cert_, channel_name_, uid_, UserRole::kRolePublisher,
            expire_, expire_);

        AccessToken2 parser;
        parser.FromString(token);

        EXPECT_EQ(parser.signature_, parser.GenerateSignature(app_cert_));

        EXPECT_EQ(parser.app_id_, app_id_);
        EXPECT_EQ(parser.expire_, expire_);
        EXPECT_EQ(parser.services_.size(), 1);

        Service *service = parser.services_.begin()->second.get();

        EXPECT_EQ(dynamic_cast<ServiceRtc *>(service)->channel_name_,
                  channel_name_);
        EXPECT_EQ(dynamic_cast<ServiceRtc *>(service)->account_, account_);

        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegeJoinChannel], expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishAudioStream],
                  expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishVideoStream],
                  expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishDataStream],
                  expire_);
    }

    void TestRtcTokenBuilderWithAccount()
    {
        std::string token = RtcTokenBuilder2::BuildTokenWithUserAccount(
            app_id_, app_cert_, channel_name_, account_, UserRole::kRolePublisher,
            expire_, expire_);

        AccessToken2 parser;
        parser.FromString(token);

        EXPECT_EQ(parser.signature_, parser.GenerateSignature(app_cert_));

        EXPECT_EQ(parser.app_id_, app_id_);
        EXPECT_EQ(parser.expire_, expire_);
        EXPECT_EQ(parser.services_.size(), 1);

        Service *service = parser.services_.begin()->second.get();

        EXPECT_EQ(dynamic_cast<ServiceRtc *>(service)->channel_name_,
                  channel_name_);
        EXPECT_EQ(dynamic_cast<ServiceRtc *>(service)->account_, account_);

        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegeJoinChannel], expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishAudioStream],
                  expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishVideoStream],
                  expire_);
        EXPECT_EQ(service->privileges_[ServiceRtc::kPrivilegePublishDataStream],
                  expire_);
    }

private:
    std::string app_id_;
    std::string app_cert_;
    std::string channel_name_;
    std::string account_;

    uint32_t uid_;
    uint32_t expire_;
};

TEST_F(RtcTokenBuilder2_test, testRtcTokenBuilderWithUid)
{
    TestRtcTokenBuilderWithUid();
}
TEST_F(RtcTokenBuilder2_test, testRtcTokenBuilderWithAccount)
{
    TestRtcTokenBuilderWithAccount();
}
