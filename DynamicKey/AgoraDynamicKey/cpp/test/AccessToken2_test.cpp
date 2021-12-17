// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/AccessToken2.h"

#include <gtest/gtest.h>

#include <string>

using namespace agora::tools;

class AccessToken2_test : public testing::Test {
 protected:
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_certificate_ = "5CFd2fd1755d40ecb72977518be15d3b";
    channel_name_ = "7d72365eb983485397e3e3f9d460bdda";
    user_id_ = "test_user";

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

  void VerifyServiceChat(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_chat = dynamic_cast<ServiceChat *>(l);
    auto r_chat = dynamic_cast<ServiceChat *>(r);

    EXPECT_EQ(l_chat->user_id_, r_chat->user_id_);
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

    auto signature = k7.GenerateSignature(app_certificate_);
    EXPECT_EQ(k7.signature_, signature);

    EXPECT_EQ(k7.app_id_, key->app_id_);
    EXPECT_EQ(k7.expire_, key->expire_);
    EXPECT_EQ(k7.salt_, key->salt_);
    EXPECT_EQ(k7.issue_ts_, key->issue_ts_);

    EXPECT_EQ(k7.services_.size(), key->services_.size());

    using VerifyServiceHandler =
        void (AccessToken2_test::*)(Service *, Service *);
    static const std::map<uint16_t, VerifyServiceHandler> kVerifyServices = {
        {ServiceRtc::kServiceType, &AccessToken2_test::VerifyServiceRtc},
        {ServiceChat::kServiceType, &AccessToken2_test::VerifyServiceChat},
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

  void TestAccessToken2WithIntUid() {
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

  void TestAccessToken2WithIntUidZero() {
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

  void TestAccessToken2WithStringUid() {
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

  void TestAccessToken2ChatUser() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceChat(account_));
    service->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);

    key.AddService(std::move(service));

    std::string expected = 
        "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTU"
        "zSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDA"
        "B+lHrg=";

    VerifyAccessToken2(expected, &key);
  }

  void TestAccessToken2ChatApp() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceChat());
    service->AddPrivilege(ServiceChat::kPrivilegeApp, expire_);

    key.AddService(std::move(service));

    std::string expected = 
        "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSama"
        "QbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr";

    VerifyAccessToken2(expected, &key);
  }

  void TestAccessToken2WithMultiService() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> rtc(new ServiceRtc(channel_name_, uid_));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, expire_);

    std::unique_ptr<Service> chat(new ServiceChat(account_));
    chat->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);

    key.AddService(std::move(rtc));
    key.AddService(std::move(chat));

    std::string expected =
        "007eJxTYLh59YaCUHZeRLXJsRSTDvfv2SV2uddsV+m05Vx5HaP59bMCg6W5gbOjsWlKqpl"
        "BsomJmYlpUlJiqkWikaGpgZlhkrGx+xcBhggmBgZGBgYGJiDJAsQgPhOYZAaTLGBSgcE8x"
        "dzI2Mw0NcnSwtjEwtTY0jzVONU4zTLFxMwgKSUlkYvByMLCyNjE0MjcmBVoDsQkZFEAlCc"
        "pOg==";

    VerifyAccessToken2(expected, &key);
  }

 private:
  std::string app_id_;
  std::string app_certificate_;
  std::string channel_name_;
  std::string account_;
  std::string user_id_;

  uint32_t uid_;
  uint32_t expire_;
  uint32_t issue_ts_;
};

TEST_F(AccessToken2_test, testAccessToken2WithIntUid) {
  TestAccessToken2WithIntUid();
}
TEST_F(AccessToken2_test, testAccessToken2WithIntUidZero) {
  TestAccessToken2WithIntUidZero();
}
TEST_F(AccessToken2_test, testAccessToken2WithStringUid) {
  TestAccessToken2WithStringUid();
}
TEST_F(AccessToken2_test, testAccessToken2ChatUser) {
  TestAccessToken2ChatUser();
}
TEST_F(AccessToken2_test, testAccessToken2ChatApp) {
  TestAccessToken2ChatApp();
}
TEST_F(AccessToken2_test, testAccessToken2WithMultiService) {
  TestAccessToken2WithMultiService();
}
