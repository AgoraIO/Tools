// Copyright (c) 2014-2017 Agora.io, Inc.
//

// #define private public
// #define protected public

#include "../src/RtmTokenBuilder2.h"

#include <gtest/gtest.h>

#include "../src/AccessToken2.h"

using namespace agora::tools;

class RtmTokenBuilder2_test : public testing::Test {
 protected:
  // Initializes deterministic Token007 RTM fields shared by the test case.
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_cert_ = "5CFd2fd1755d40ecb72977518be15d3b";
    user_id_ = "test_user";
    expire_ = 900;
  }

  // Tests Token007 RTM generation, parsing, and signature validation.
  void TestRtmTokenBuilder() {
    std::string token =
        RtmTokenBuilder2::BuildToken(app_id_, app_cert_, user_id_, expire_);

    AccessToken2 parser;
    bool parsed = parser.FromString(token);

    EXPECT_EQ(parser.signature_, parser.GenerateSignature(app_cert_));

    ASSERT_TRUE(parsed);
    EXPECT_EQ(parser.app_id_, app_id_);
    EXPECT_EQ(parser.expire_, expire_);
    EXPECT_EQ(parser.services_.size(), 1);

    Service *service = parser.services_.begin()->second.get();

    EXPECT_EQ(dynamic_cast<ServiceRtm *>(service)->user_id_, user_id_);
    EXPECT_EQ(service->privileges_[ServiceRtm::kPrivilegeLogin], expire_);
  }

  // Tests RTM2 generation and parsing with resource-level permissions.
  void TestRtm2TokenBuilder() {
    ServiceRtm2::Permissions permissions;
    permissions.Add(ServiceRtm2::Permissions::kMessageChannels, ServiceRtm2::Permissions::kRead, {"message-a", "message-b"});
    permissions.Add(ServiceRtm2::Permissions::kStreamChannels, ServiceRtm2::Permissions::kWrite, {"stream-a"});
    permissions.Add(ServiceRtm2::Permissions::kGroupChannels, ServiceRtm2::Permissions::kRead, {"group-a"});
    permissions.Add(ServiceRtm2::Permissions::kServerGroups, ServiceRtm2::Permissions::kWrite, {"server-group-a"});
    permissions.Add(ServiceRtm2::Permissions::kUsers, ServiceRtm2::Permissions::kRead, {"user-a"});

    std::string token = RtmTokenBuilder2::BuildToken(app_id_, app_cert_, user_id_, permissions, expire_);

    AccessToken2 parser;
    ASSERT_TRUE(parser.FromString(token));
    EXPECT_EQ(kTokenVerifySuccess, parser.VerifySignature(app_cert_));
    ASSERT_EQ(1, parser.services_.size());

    auto *service = dynamic_cast<ServiceRtm2 *>(parser.services_.begin()->second.get());
    ASSERT_NE(nullptr, service);
    EXPECT_EQ(user_id_, service->user_id_);
    EXPECT_EQ(expire_, service->privileges_.at(ServiceRtm2::kPrivilegeLogin));
    EXPECT_EQ(permissions.details_, service->permissions_.details_);
  }

 private:
  std::string app_id_;
  std::string app_cert_;
  std::string user_id_;
  uint32_t expire_;
};

// Tests Token007 RTM token generation.
TEST_F(RtmTokenBuilder2_test, testRtmTokenBuilder) { TestRtmTokenBuilder(); }

// Tests Token007 RTM2 token generation with resource-level permissions.
TEST_F(RtmTokenBuilder2_test, testRtm2TokenBuilder) { TestRtm2TokenBuilder(); }
