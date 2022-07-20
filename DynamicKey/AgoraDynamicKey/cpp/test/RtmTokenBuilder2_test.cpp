// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/RtmTokenBuilder2.h"

#include <gtest/gtest.h>

#include "../src/AccessToken2.h"

using namespace agora::tools;

class RtmTokenBuilder2_test : public testing::Test {
 protected:
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_cert_ = "5CFd2fd1755d40ecb72977518be15d3b";
    user_id_ = "test_user";
    expire_ = 900;
  }

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

 private:
  std::string app_id_;
  std::string app_cert_;
  std::string user_id_;
  uint32_t expire_;
};

TEST_F(RtmTokenBuilder2_test, testRtmTokenBuilder) { TestRtmTokenBuilder(); }
