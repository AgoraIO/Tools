// Copyright (c) 2014-2017 Agora.io, Inc.
//

#define private public
#define protected public

#include "../src/AccessToken2.h"
#include "../src/md5/md5.h"

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

    room_uuid_ = "123";
    role_ = 1;
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

    auto l_rtc = dynamic_cast<ServiceStreaming *>(l);
    auto r_rtc = dynamic_cast<ServiceStreaming *>(r);

    EXPECT_EQ(l_rtc->channel_name_, r_rtc->channel_name_);
    EXPECT_EQ(l_rtc->account_, r_rtc->account_);
  }

  void VerifyServiceRtns(Service *l, Service *r) {
    VerifyService(l, r);

    (void)dynamic_cast<ServiceRtns *>(l);
    (void)dynamic_cast<ServiceRtns *>(r);
  }

  void VerifyServiceChat(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_chat = dynamic_cast<ServiceChat *>(l);
    auto r_chat = dynamic_cast<ServiceChat *>(r);

    EXPECT_EQ(l_chat->user_id_, r_chat->user_id_);
  }

  void VerifyServiceFCdn(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_fcdn = dynamic_cast<ServiceFCdn *>(l);
    auto r_fcdn = dynamic_cast<ServiceFCdn *>(r);

    EXPECT_EQ(l_fcdn->channel_name_, r_fcdn->channel_name_);
    EXPECT_EQ(l_fcdn->account_, r_fcdn->account_);
  }

  void VerifyServiceEducation(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_education = dynamic_cast<ServiceEducation *>(l);
    auto r_education = dynamic_cast<ServiceEducation *>(r);

    EXPECT_EQ(l_education->room_uuid_, r_education->room_uuid_);
    EXPECT_EQ(l_education->user_uuid_, r_education->user_uuid_);
    EXPECT_EQ(l_education->role_, r_education->role_);
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
        {ServiceRtm::kServiceType, &AccessToken2_test::VerifyServiceRtm},
        {ServiceStreaming::kServiceType,
         &AccessToken2_test::VerifyServiceStreaming},
        {ServiceRtns::kServiceType, &AccessToken2_test::VerifyServiceRtns},
        {ServiceChat::kServiceType, &AccessToken2_test::VerifyServiceChat},
        {ServiceFCdn::kServiceType, &AccessToken2_test::VerifyServiceFCdn},
        {ServiceEducation::kServiceType,
         &AccessToken2_test::VerifyServiceEducation},
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

  void TestAccessToken2Rtm() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceRtm(account_));
    service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire_);

    key.AddService(std::move(service));

    std::string expected = 
        "007eJxTYEhuZrAR/XT+XPihI+6t4t5F9RtUltw9em3Pwi2sr6P/lAspMFiaGzg7GpumpJo"
        "ZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJiBmBPO5GIwsLIyMTQyNzI0Bn"
        "dAdKg==";

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

  void TestAccessToken2FCdnWithIntUid() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceFCdn(channel_name_, uid_));
    service->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);

    key.AddService(std::move(service));

    std::string expected =
      "007eJxTYCjLT2v/scTt9SaxJB+F9L8T/mbzlNoVKXDPEnO/+zdu0WIFBktzA2dHY9OUVDODZ"
      "BMTMxPTpKTEVItEI0NTAzPDJGNj9y8CDBFMDAyMDCDMBsSMYL4Cg3mKuZGxmWlqkqWFsYmFq"
      "bGleapxqnGaZYqJmUFSSkoiF4ORhYWRsYmhkbkxAK3JJMU=";
    VerifyAccessToken2(expected, &key);
  }

  void TestAccessToken2FCdnWithIntUidZero() {
    uint32_t uid_zero = 0;
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceFCdn(channel_name_, uid_zero));
    service->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);

    key.AddService(std::move(service));

    std::string expected =
      "007eJxTYDgYE3trdcOmk15Xedl3MCQbaIrfrDioPNfhQk5Pr2OIg5YCg6W5gbOjsWlKqplBs"
      "omJmYlpUlJiqkWikaGpgZlhkrGx+xcBhggmBgZGBhBmA2JGMF+BwTzF3MjYzDQ1ydLC2MTC1"
      "NjSPNU41TjNMsXEzCApJSWRgQEAyy8hcA==";
    VerifyAccessToken2(expected, &key);
  }

  void TestAccessToken2FCdnWithStringUid() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceFCdn(channel_name_, account_));
    service->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);

    key.AddService(std::move(service));

    std::string expected =
      "007eJxTYCjLT2v/scTt9SaxJB+F9L8T/mbzlNoVKXDPEnO/+zdu0WIFBktzA2dHY9OUVDODZ"
      "BMTMxPTpKTEVItEI0NTAzPDJGNj9y8CDBFMDAyMDCDMBsSMYL4Cg3mKuZGxmWlqkqWFsYmFq"
      "bGleapxqnGaZYqJmUFSSkoiF4ORhYWRsYmhkbkxAK3JJMU=";
    VerifyAccessToken2(expected, &key);
  }

  void TestAccessToken2EducationRoomUser() {
    MD5 h{user_id_};
    std::string char_user_id(reinterpret_cast<const char *>(h.getDigest()));

    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> education_service(
        new ServiceEducation(room_uuid_, user_id_, role_));
    education_service->AddPrivilege(ServiceEducation::kPrivilegeRoomUser,
                                    expire_);
    token.AddService(std::move(education_service));

    std::unique_ptr<Service> rtm_service(new ServiceRtm(user_id_));
    rtm_service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire_);
    token.AddService(std::move(rtm_service));

    std::unique_ptr<Service> chat_service(new ServiceChat(char_user_id));
    chat_service->AddPrivilege(ServiceChat::kPrivilegeApp, expire_);
    token.AddService(std::move(chat_service));

    std::string expected =
        "007eJxTYAi07DjM9jO3cd7mI4qim1Zf2ztvi7ygfvepvwxPlPs2u81RYLA0N3B2NDZNSTU"
        "zSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwMzABKQZwXxOhpLU4pL40uLUI"
        "lagEBNYUIBh7sIfD9admdvWvVYwULMgq5wNroGZwdDIGEkXIwMAtIUstA==";

    VerifyAccessToken2(expected, &token);
  }

  void TestAccessToken2EducationUser() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> education_service(
        new ServiceEducation(room_uuid_, user_id_, role_));
    education_service->AddPrivilege(ServiceEducation::kPrivilegeUser, expire_);
    token.AddService(std::move(education_service));

    std::string expected =
        "007eJxTYBCyYwu2b9n3YXqc45wD6w1+13VKfFPQv/"
        "q7crOWbCUb30YFBktzA2dHY9OUVDODZBMTMxPTpKTEVItEI0NTAzPDJGNj9y8CDBFMDAyM"
        "DCDMBsRMYD4zg6GRMSdDSWpxSXxpcWoRIwMAnhsddg==";

    VerifyAccessToken2(expected, &token);
  }

  void TestAccessToken2EducationApp() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> education_service(
        new ServiceEducation(room_uuid_, user_id_, role_));
    education_service->AddPrivilege(ServiceEducation::kPrivilegeApp, expire_);
    token.AddService(std::move(education_service));

    std::string expected =
        "007eJxTYFB+"
        "ba86NzRtXsTrZvF0IfvsgozDht4SxcL7i5dNZzntv1KBwdLcwNnR2DQl1cwg2cTEzMQ0KS"
        "kx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwizATEzmM/"
        "MYGhkzMlQklpcEl9anFrEyAAANqwcXw==";

    VerifyAccessToken2(expected, &token);
  }

  void TestAccessToken2WithMultiService() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> rtc(new ServiceRtc(channel_name_, uid_));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, expire_);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, expire_);

    std::unique_ptr<Service> rtm(new ServiceRtm(user_id_));
    rtm->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire_);

    std::unique_ptr<Service> streaming(
        new ServiceStreaming(channel_name_, uid_));
    streaming->AddPrivilege(ServiceStreaming::kPrivilegePublishMixStream,
                            expire_);
    streaming->AddPrivilege(ServiceStreaming::kPrivilegePublishRawStream,
                            expire_);

    std::unique_ptr<Service> rtns(new ServiceRtns());
    rtns->AddPrivilege(ServiceRtns::kPrivilegeLogin, expire_);

    std::unique_ptr<Service> chat(new ServiceChat(account_));
    chat->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);

    std::unique_ptr<Service> fcdn(new ServiceFCdn(channel_name_, account_));
    fcdn->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);
    fcdn->AddPrivilege(ServiceFCdn::kPrivilegePlay, expire_);

    key.AddService(std::move(rtc));
    key.AddService(std::move(rtm));
    key.AddService(std::move(streaming));
    key.AddService(std::move(rtns));
    key.AddService(std::move(chat));
    key.AddService(std::move(fcdn));

    std::string expected =
      "007eJxTYKh0mlnkw+3LHxCYO3mX2tZVpr5GSU1tJsmvWz0Wq75d4aXAYGlu4OxobJqSamaQb"
      "GJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRgYGBDUiyADGIzwQmmcEkC5hUYDBPMTcyN"
      "jNNTbK0MDaxMDW2NE81TjVOs0wxMTNISklJ5GIwsrAwMjYxNDI3ZgKaAzGJk6EktbgkvrQ4t"
      "YiZgQnFeNKMZIEbyQpnIcuzUWQ6AIDlQjQ=";

    VerifyAccessToken2(expected, &key);
  }

 private:
  std::string app_id_;
  std::string app_certificate_;
  std::string channel_name_;
  std::string account_;
  std::string user_id_;
  std::string room_uuid_;

  uint32_t uid_;
  uint32_t expire_;
  uint32_t issue_ts_;
  int16_t role_;
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
TEST_F(AccessToken2_test, testAccessToken2Rtm) {
  TestAccessToken2Rtm();
}
TEST_F(AccessToken2_test, testAccessToken2ChatUser) {
  TestAccessToken2ChatUser();
}
TEST_F(AccessToken2_test, testAccessToken2ChatApp) {
  TestAccessToken2ChatApp();
}
TEST_F(AccessToken2_test, testAccessToken2FCdnWithIntUid) {
  TestAccessToken2FCdnWithIntUid();
}
TEST_F(AccessToken2_test, testAccessToken2FCdnWithIntUidZero) {
  TestAccessToken2FCdnWithIntUidZero();
}
TEST_F(AccessToken2_test, testAccessToken2FCdnWithStringUid) {
  TestAccessToken2FCdnWithStringUid();
}
TEST_F(AccessToken2_test, testAccessToken2EducationRoomUser) {
  TestAccessToken2EducationRoomUser();
}
TEST_F(AccessToken2_test, testAccessToken2EducationUser) {
  TestAccessToken2EducationUser();
}
TEST_F(AccessToken2_test, testAccessToken2EducationApp) {
  TestAccessToken2EducationApp();
}
TEST_F(AccessToken2_test, testAccessToken2WithMultiService) {
  TestAccessToken2WithMultiService();
}
