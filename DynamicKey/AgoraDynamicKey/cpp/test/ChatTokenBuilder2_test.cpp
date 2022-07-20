// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/ChatTokenBuilder2.h"

#include <gtest/gtest.h>

#include "../src/AccessToken2.h"

using namespace agora::tools;

class ChatTokenBuilder2_test : public testing::Test {
 protected:
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_cert_ = "5CFd2fd1755d40ecb72977518be15d3b";
    user_id_ = "test_user";
    expire_ = 600;
  }

  void TestChatTokenBuilderBuildUserToken() {
    std::string token = ChatTokenBuilder2::BuildUserToken(app_id_,
      app_cert_, user_id_, expire_);

    AccessToken2 parser;
    bool parsed = parser.FromString(token);

    EXPECT_EQ(parser.signature_, parser.GenerateSignature(app_cert_));

    ASSERT_TRUE(parsed);
    EXPECT_EQ(parser.app_id_, app_id_);
    EXPECT_EQ(parser.expire_, expire_);
    EXPECT_EQ(parser.services_.size(), 1);

    Service *service = parser.services_.begin()->second.get();

    EXPECT_EQ(dynamic_cast<ServiceChat *>(service)->user_id_, user_id_);
    EXPECT_EQ(service->privileges_[ServiceChat::kPrivilegeUser], expire_);
  }


  void TestChatTokenBuilderBuildAppToken() {
    std::string token = ChatTokenBuilder2::BuildAppToken(app_id_,
      app_cert_, expire_);

    AccessToken2 parser;
    bool parsed = parser.FromString(token);

    EXPECT_EQ(parser.signature_, parser.GenerateSignature(app_cert_));

    ASSERT_TRUE(parsed);
    EXPECT_EQ(parser.app_id_, app_id_);
    EXPECT_EQ(parser.expire_, expire_);
    EXPECT_EQ(parser.services_.size(), 1);

    Service *service = parser.services_.begin()->second.get();

    EXPECT_EQ(service->privileges_[ServiceChat::kPrivilegeApp], expire_);
  }

 private:
  std::string app_id_;
  std::string app_cert_;
  std::string user_id_;
  uint32_t expire_;
};

TEST_F(ChatTokenBuilder2_test, testChatTokenBuilderBuildUserToken) { TestChatTokenBuilderBuildUserToken(); }
TEST_F(ChatTokenBuilder2_test, testChatTokenBuilderBuildAppToken) { TestChatTokenBuilderBuildAppToken(); }
