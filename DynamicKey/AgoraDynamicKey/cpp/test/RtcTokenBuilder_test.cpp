// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/RtcTokenBuilder.h"

#include <gtest/gtest.h>
#include <zlib.h>

#include <string>

#include "../src/AccessToken.h"

using namespace agora::tools;

class RtcTokenBuilder_test : public testing::Test
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

        channel_name_crc_ = crc32(
            0, reinterpret_cast<Bytef *>(const_cast<char *>(channel_name_.c_str())),
            channel_name_.length());
        account_crc_ =
            crc32(0, reinterpret_cast<Bytef *>(const_cast<char *>(account_.c_str())),
                  account_.length());
    }

    void TestRtcTokenBuilderWithUid()
    {
        std::string token = RtcTokenBuilder::buildTokenWithUid(
            app_id_, app_cert_, channel_name_, uid_, Role_Publisher, expire_);

        AccessToken parser;
        parser.FromString(token);
        EXPECT_EQ(parser.app_id_, app_id_);
        EXPECT_EQ(parser.crc_channel_name_, channel_name_crc_);
        EXPECT_EQ(parser.crc_uid_, account_crc_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream],
                  expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream],
                  expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream],
                  expire_);
        EXPECT_EQ(
            AccessToken::GenerateSignature(app_cert_, app_id_, channel_name_,
                                           account_, parser.message_raw_content_),
            parser.signature_);
    }

    void TestRtcTokenBuilderWithAccount()
    {
        std::string token = RtcTokenBuilder::buildTokenWithUserAccount(
            app_id_, app_cert_, channel_name_, account_, Role_Publisher, expire_);

        AccessToken parser;
        parser.FromString(token);
        EXPECT_EQ(parser.app_id_, app_id_);
        EXPECT_EQ(parser.crc_channel_name_, channel_name_crc_);
        EXPECT_EQ(parser.crc_uid_, account_crc_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kJoinChannel], expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishAudioStream],
                  expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishVideoStream],
                  expire_);
        EXPECT_EQ(parser.message_.messages[AccessToken::kPublishDataStream],
                  expire_);
        EXPECT_EQ(
            AccessToken::GenerateSignature(app_cert_, app_id_, channel_name_,
                                           account_, parser.message_raw_content_),
            parser.signature_);
    }

private:
    std::string app_id_;
    std::string app_cert_;
    std::string channel_name_;
    std::string account_;

    uint32_t uid_;
    uint32_t expire_;

    uint32_t channel_name_crc_;
    uint32_t account_crc_;
};

TEST_F(RtcTokenBuilder_test, testRtcTokenBuilderWithUid)
{
    TestRtcTokenBuilderWithUid();
}
TEST_F(RtcTokenBuilder_test, testRtcTokenBuilderWithAccount)
{
    TestRtcTokenBuilderWithAccount();
}