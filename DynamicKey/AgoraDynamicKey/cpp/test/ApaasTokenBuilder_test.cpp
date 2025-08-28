// Copyright (c) 2014-2022 Agora.io, Inc.
//

// #define private public
// #define protected public

#include "../src/ApaasTokenBuilder.h"

#include <gtest/gtest.h>

#include <string>

#include "../src/AccessToken2.h"

using namespace agora::tools;

class ApaasTokenBuilder_test : public testing::Test {
 protected:
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_cert_ = "5CFd2fd1755d40ecb72977518be15d3b";
    room_uuid_ = "123";
    user_id_ = "2882341273";
    role_ = 1;
    expire_ = 900;

    chat_user_id_ = "6063383428a36fba3fb6030becf8094e";
  }

  void TestRoomUserToken() {
    std::string token_str = ApaasTokenBuilder::BuildRoomUserToken(app_id_, app_cert_, room_uuid_, user_id_, role_, expire_);
    AccessToken2 token;
    ASSERT_TRUE(token.FromString(token_str));

    EXPECT_EQ(app_id_, token.app_id_);
    EXPECT_EQ(expire_, token.expire_);

    ASSERT_EQ(3, token.services_.size());
    ASSERT_TRUE(token.services_.count(ServiceApaas::kServiceType));
    ASSERT_TRUE(token.services_.count(ServiceRtm::kServiceType));
    ASSERT_TRUE(token.services_.count(ServiceChat::kServiceType));

    const auto &apaas_service = dynamic_cast<const ServiceApaas &>(*token.services_.find(ServiceApaas::kServiceType)->second);

    EXPECT_EQ(room_uuid_, apaas_service.room_uuid_);
    EXPECT_EQ(user_id_, apaas_service.user_uuid_);
    EXPECT_EQ(role_, apaas_service.role_);
    ASSERT_EQ(1, apaas_service.privileges_.size());
    ASSERT_TRUE(apaas_service.privileges_.count(ServiceApaas::kPrivilegeRoomUser));
    EXPECT_EQ(expire_, apaas_service.privileges_.at(ServiceApaas::kPrivilegeRoomUser));

    const auto &rtm_service = dynamic_cast<const ServiceRtm &>(*token.services_.find(ServiceRtm::kServiceType)->second);
    EXPECT_EQ(user_id_, rtm_service.user_id_);
    ASSERT_EQ(1, rtm_service.privileges_.size());
    ASSERT_TRUE(rtm_service.privileges_.count(ServiceRtm::kPrivilegeLogin));
    EXPECT_EQ(expire_, rtm_service.privileges_.at(ServiceRtm::kPrivilegeLogin));

    const auto &chat_service = dynamic_cast<const ServiceChat &>(*token.services_.find(ServiceChat::kServiceType)->second);
    EXPECT_EQ(chat_user_id_, chat_service.user_id_);
    ASSERT_EQ(1, chat_service.privileges_.size());
    ASSERT_TRUE(chat_service.privileges_.count(ServiceChat::kPrivilegeUser));
    EXPECT_EQ(expire_, chat_service.privileges_.at(ServiceChat::kPrivilegeUser));
  }

  void TestUserToken() {
    std::string token_str = ApaasTokenBuilder::BuildUserToken(app_id_, app_cert_, user_id_, expire_);
    AccessToken2 token;
    ASSERT_TRUE(token.FromString(token_str));

    EXPECT_EQ(app_id_, token.app_id_);
    EXPECT_EQ(expire_, token.expire_);

    ASSERT_EQ(1, token.services_.size());
    ASSERT_TRUE(token.services_.count(ServiceApaas::kServiceType));

    const auto &apaas_service = dynamic_cast<const ServiceApaas &>(*token.services_.find(ServiceApaas::kServiceType)->second);

    EXPECT_EQ("", apaas_service.room_uuid_);
    EXPECT_EQ(user_id_, apaas_service.user_uuid_);
    EXPECT_EQ(-1, apaas_service.role_);
    ASSERT_EQ(1, apaas_service.privileges_.size());
    ASSERT_TRUE(apaas_service.privileges_.count(ServiceApaas::kPrivilegeUser));
    EXPECT_EQ(expire_, apaas_service.privileges_.at(ServiceApaas::kPrivilegeUser));
  }

  void TestAppToken() {
    std::string token_str = ApaasTokenBuilder::BuildAppToken(app_id_, app_cert_, expire_);
    AccessToken2 token;
    ASSERT_TRUE(token.FromString(token_str));

    EXPECT_EQ(app_id_, token.app_id_);
    EXPECT_EQ(expire_, token.expire_);

    ASSERT_EQ(1, token.services_.size());
    ASSERT_TRUE(token.services_.count(ServiceApaas::kServiceType));

    const auto &apaas_service = dynamic_cast<const ServiceApaas &>(*token.services_.find(ServiceApaas::kServiceType)->second);

    EXPECT_EQ("", apaas_service.room_uuid_);
    EXPECT_EQ("", apaas_service.user_uuid_);
    EXPECT_EQ(-1, apaas_service.role_);
    ASSERT_EQ(1, apaas_service.privileges_.size());
    ASSERT_TRUE(apaas_service.privileges_.count(ServiceApaas::kPrivilegeApp));
    EXPECT_EQ(expire_, apaas_service.privileges_.at(ServiceApaas::kPrivilegeApp));
  }

 private:
  std::string app_id_;
  std::string app_cert_;
  std::string room_uuid_;
  std::string user_id_;
  int16_t role_;
  uint32_t expire_;

  std::string chat_user_id_;
};

TEST_F(ApaasTokenBuilder_test, TestRoomUserToken) { TestRoomUserToken(); }
TEST_F(ApaasTokenBuilder_test, TestUserToken) { TestUserToken(); }
TEST_F(ApaasTokenBuilder_test, TestAppToken) { TestAppToken(); }
