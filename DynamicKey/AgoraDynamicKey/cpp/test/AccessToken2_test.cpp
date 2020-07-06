// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/AccessToken2.h"

#include <gtest/gtest.h>
#include <stdint.h>

#include <string>

using namespace agora::tools;

class AccessToken2_test : public testing::Test {
 protected:
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_certificate_ = "5CFd2fd1755d40ecb72977518be15d3b";
    channel_name_ = "7d72365eb983485397e3e3f9d460bdda";
    uid_ = 2882341273u;
    account_ = "2882341273";
    expire_ = 600;
    issue_ts_ = 1111111;
  }

  void VerifyService(Service *l, Service *r) {
    EXPECT_EQ(l->privileges_.size(), r->privileges_.size());

    auto l_it = l->privileges_.begin();
    auto r_it = r->privileges_.begin();
    for (; l_it != l->privileges_.end() && r_it != r->privileges_.end();
         ++l_it, ++r_it) {
      EXPECT_EQ(l_it->first, r_it->first);
      EXPECT_EQ(l_it->second, r_it->second);
    }
  }

  void VerifyServiceRtc(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtc = dynamic_cast<ServiceRtc *>(l);
    auto r_rtc = dynamic_cast<ServiceRtc *>(r);

    EXPECT_EQ(l_rtc->channel_name_, r_rtc->channel_name_);
    EXPECT_EQ(l_rtc->account_, r_rtc->account_);
  }

  void VerifyServiceRtm(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtc = dynamic_cast<ServiceRtm *>(l);
    auto r_rtc = dynamic_cast<ServiceRtm *>(r);

    EXPECT_EQ(l_rtc->user_id_, r_rtc->user_id_);
  }

  void VerifyServiceStreaming(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtc = dynamic_cast<ServiceRtc *>(l);
    auto r_rtc = dynamic_cast<ServiceRtc *>(r);

    EXPECT_EQ(l_rtc->channel_name_, r_rtc->channel_name_);
    EXPECT_EQ(l_rtc->account_, r_rtc->account_);
  }

  void VerifyAccessToken2(const std::string &expected, AccessToken2 *key) {
    std::string result = key->Build();
    EXPECT_EQ(expected, result);

    if (expected.empty()) {
      return;
    }

    AccessToken2 k7;
    bool parsed = k7.FromString(result);
    ASSERT_TRUE(parsed);
    EXPECT_EQ(k7.app_id_, key->app_id_);
    EXPECT_EQ(k7.expire_, key->expire_);
    EXPECT_EQ(k7.salt_, key->salt_);
    EXPECT_EQ(k7.issue_ts_, key->issue_ts_);

    EXPECT_EQ(k7.services_.size(), key->services_.size());

    using VerifyServiceHandler =
        void (AccessToken2_test::*)(Service *, Service *);
    static const std::map<uint16_t, VerifyServiceHandler> kVerifyServices = {
        {ServiceRtc::kServiceType, &AccessToken2_test::VerifyServiceRtc},
        {ServiceRtm::kServiceType, &AccessToken2_test::VerifyServiceRtm},
        {ServiceStreaming::kServiceType,
         &AccessToken2_test::VerifyServiceStreaming},
    };

    auto k7_it = k7.services_.begin();
    auto key_it = key->services_.begin();
    for (; k7_it != k7.services_.end() && key_it != key->services_.end();
         ++k7_it, ++key_it) {
      EXPECT_EQ(k7_it->first, key_it->first);

      Service *k7_s = k7_it->second.get();
      Service *key_s = key_it->second.get();

      (this->*(kVerifyServices.at(k7_it->first)))(k7_s, key_s);
    }
  }

  void testAccessTokenWithIntUid() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceRtc(channel_name_, uid_));
    service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);

    key.AddService(std::move(service));

    std::string expected =
        "007eJxTYBBbsMMnKq7p9Hf/"
        "HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDc"
        "wMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkp"
        "iVwMRhYWRsYmhkbmxgDCaiTj";
    VerifyAccessToken2(expected, &key);
  }

  void testAccessTokenWithIntUidZero() {
    uint32_t uid_zero = 0;
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceRtc(channel_name_, uid_zero));
    service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);

    key.AddService(std::move(service));

    std::string expected =
        "007eJxTYLhzZP08Lxa1Pg57+TcXb/"
        "3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN"
        "3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMAD"
        "acImo=";
    VerifyAccessToken2(expected, &key);
  }

  void testAccessTokenWithStringUid() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceRtc(channel_name_, account_));
    service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);

    key.AddService(std::move(service));

    std::string expected =
        "007eJxTYBBbsMMnKq7p9Hf/"
        "HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDc"
        "wMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkp"
        "iVwMRhYWRsYmhkbmxgDCaiTj";
    VerifyAccessToken2(expected, &key);
  }

 private:
  std::string app_id_;
  std::string app_certificate_;
  std::string channel_name_;
  std::string account_;
  uint32_t uid_;
  uint32_t expire_;
  uint32_t issue_ts_;
};

TEST_F(AccessToken2_test, testAccessTokenWithIntUid) {
  testAccessTokenWithIntUid();
}
TEST_F(AccessToken2_test, testAccessTokenWithIntUidZero) {
  testAccessTokenWithIntUidZero();
}
TEST_F(AccessToken2_test, testAccessTokenWithStringUid) {
  testAccessTokenWithStringUid();
}
