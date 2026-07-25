// Copyright (c) 2014-2017 Agora.io, Inc.
//

// #define private public
// #define protected public

#include "../src/AccessToken2.h"

#include <gtest/gtest.h>

#include <string>
#include <vector>

#include "../src/md5/md5.h"

using namespace agora::tools;

// Represents an unsupported service type for forward compatibility tests.
class UnknownService : public Service {
 public:
  // Creates a service with a type unsupported by the current parser.
  explicit UnknownService(uint16_t service_type) : Service(service_type) {}

  // Packs the unknown service using the common service payload format.
  std::string PackService() override { return Pack(dynamic_cast<const Service *>(this)); }

  // Unpacks the unknown service using the common service payload format.
  void UnpackService(Unpacker *unpacker) override { *unpacker >> dynamic_cast<Service *>(this); }

  // Creates an independent copy of the unknown service.
  std::unique_ptr<Service> Clone() const override {
    std::unique_ptr<UnknownService> service(new UnknownService(type_));
    service->privileges_ = privileges_;
    return std::move(service);
  }
};

class AccessToken2_test : public testing::Test {
 protected:
  // Initializes deterministic token fields shared by the test cases.
  virtual void SetUp() override {
    app_id_ = "970CA35de60c44645bbae8a215061b33";
    app_certificate_ = "5CFd2fd1755d40ecb72977518be15d3b";
    channel_name_ = "7d72365eb983485397e3e3f9d460bdda";
    user_id_ = "test_user";

    uid_ = 2882341273u;
    account_ = "2882341273";
    expire_ = 600;
    issue_ts_ = 1111111;
    expiredTs_ = time(nullptr) + 3600;

    room_uuid_ = "123";
    role_ = 1;
  }

  // Builds an RTC service with all RTC privileges enabled.
  std::unique_ptr<Service> BuildRtcService(std::string channelName, uint32_t uid, uint32_t expiredTs) {
    std::unique_ptr<Service> rtc(new ServiceRtc(channelName, uid));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expiredTs);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, expiredTs);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, expiredTs);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, expiredTs);
    return rtc;
  }

  // Builds an RTM service with the login privilege enabled.
  std::unique_ptr<Service> BuildRtmService(std::string uidStr, uint32_t expiredTs) {
    std::unique_ptr<Service> rtm(new ServiceRtm(uidStr));
    rtm->AddPrivilege(ServiceRtm::kPrivilegeLogin, expiredTs);
    return rtm;
  }

  // Builds the RTC service used to authorize an RTM stream channel.
  std::unique_ptr<Service> BuildRtmStreamServiceAsRtc(std::string channelName, uint32_t uid, uint32_t expiredTs) {
    std::unique_ptr<Service> rtc(new ServiceRtc(channelName, uid));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expiredTs);
    rtc->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, expiredTs);
    return rtc;
  }

  // Verifies that two services contain the same privileges.
  void VerifyService(Service *l, Service *r) {
    EXPECT_EQ(l->privileges_.size(), r->privileges_.size());

    auto l_it = l->privileges_.begin();
    auto r_it = r->privileges_.begin();
    for (; l_it != l->privileges_.end() && r_it != r->privileges_.end(); ++l_it, ++r_it) {
      EXPECT_EQ(l_it->first, r_it->first);
      EXPECT_EQ(l_it->second, r_it->second);
    }
  }

  // Verifies RTC-specific fields and privileges.
  void VerifyServiceRtc(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtc = dynamic_cast<ServiceRtc *>(l);
    auto r_rtc = dynamic_cast<ServiceRtc *>(r);

    EXPECT_EQ(l_rtc->channel_name_, r_rtc->channel_name_);
    EXPECT_EQ(l_rtc->account_, r_rtc->account_);
  }

  // Verifies RTM-specific fields and privileges.
  void VerifyServiceRtm(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtc = dynamic_cast<ServiceRtm *>(l);
    auto r_rtc = dynamic_cast<ServiceRtm *>(r);

    EXPECT_EQ(l_rtc->user_id_, r_rtc->user_id_);
  }

  // Verifies Streaming-specific fields and privileges.
  void VerifyServiceStreaming(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_streaming = dynamic_cast<ServiceStreaming *>(l);
    auto r_streaming = dynamic_cast<ServiceStreaming *>(r);

    ASSERT_NE(nullptr, l_streaming);
    ASSERT_NE(nullptr, r_streaming);
    EXPECT_EQ(l_streaming->channel_name_, r_streaming->channel_name_);
    EXPECT_EQ(l_streaming->account_, r_streaming->account_);
  }

  // Verifies FPA service privileges and concrete service types.
  void VerifyServiceFpa(Service *l, Service *r) {
    VerifyService(l, r);

    (void)dynamic_cast<ServiceFpa *>(l);
    (void)dynamic_cast<ServiceFpa *>(r);
  }

  // Verifies Chat-specific fields and privileges.
  void VerifyServiceChat(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_chat = dynamic_cast<ServiceChat *>(l);
    auto r_chat = dynamic_cast<ServiceChat *>(r);

    EXPECT_EQ(l_chat->user_id_, r_chat->user_id_);
  }

  // Verifies FCDN-specific fields and privileges.
  void VerifyServiceFCdn(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_fcdn = dynamic_cast<ServiceFCdn *>(l);
    auto r_fcdn = dynamic_cast<ServiceFCdn *>(r);

    ASSERT_NE(nullptr, l_fcdn);
    ASSERT_NE(nullptr, r_fcdn);
    EXPECT_EQ(l_fcdn->channel_name_, r_fcdn->channel_name_);
    EXPECT_EQ(l_fcdn->account_, r_fcdn->account_);
  }

  // Verifies APaaS-specific fields and privileges.
  void VerifyServiceApaas(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_apaas = dynamic_cast<ServiceApaas *>(l);
    auto r_apaas = dynamic_cast<ServiceApaas *>(r);

    EXPECT_EQ(l_apaas->room_uuid_, r_apaas->room_uuid_);
    EXPECT_EQ(l_apaas->user_uuid_, r_apaas->user_uuid_);
    EXPECT_EQ(l_apaas->role_, r_apaas->role_);
  }

  // Verifies RTM2-specific fields, privileges, and resource permissions.
  void VerifyServiceRtm2(Service *l, Service *r) {
    VerifyService(l, r);

    auto l_rtm2 = dynamic_cast<ServiceRtm2 *>(l);
    auto r_rtm2 = dynamic_cast<ServiceRtm2 *>(r);

    ASSERT_NE(nullptr, l_rtm2);
    ASSERT_NE(nullptr, r_rtm2);
    EXPECT_EQ(l_rtm2->user_id_, r_rtm2->user_id_);
    EXPECT_EQ(l_rtm2->permissions_.details_, r_rtm2->permissions_.details_);
  }

  // Verifies an externally generated token against the expected service state.
  void VerifyParsedAccessToken2(const std::string &token, AccessToken2 *key) {
    AccessToken2 k7;
    bool parsed = k7.FromString(token);
    ASSERT_TRUE(parsed);

    auto signature = k7.GenerateSignature(app_certificate_);
    EXPECT_EQ(k7.signature_, signature);

    EXPECT_EQ(k7.app_id_, key->app_id_);
    EXPECT_EQ(k7.expire_, key->expire_);
    EXPECT_EQ(k7.salt_, key->salt_);
    EXPECT_EQ(k7.issue_ts_, key->issue_ts_);

    EXPECT_EQ(k7.services_.size(), key->services_.size());

    using VerifyServiceHandler = void (AccessToken2_test::*)(Service *, Service *);
    static const std::map<uint16_t, VerifyServiceHandler> kVerifyServices = {
        {ServiceRtc::kServiceType, &AccessToken2_test::VerifyServiceRtc},
        {ServiceRtm::kServiceType, &AccessToken2_test::VerifyServiceRtm},
        {ServiceStreaming::kServiceType, &AccessToken2_test::VerifyServiceStreaming},
        {ServiceFpa::kServiceType, &AccessToken2_test::VerifyServiceFpa},
        {ServiceChat::kServiceType, &AccessToken2_test::VerifyServiceChat},
        {ServiceFCdn::kServiceType, &AccessToken2_test::VerifyServiceFCdn},
        {ServiceApaas::kServiceType, &AccessToken2_test::VerifyServiceApaas},
        {ServiceRtm2::kServiceType, &AccessToken2_test::VerifyServiceRtm2},
    };

    auto k7_it = k7.services_.begin();
    auto key_it = key->services_.begin();
    for (; k7_it != k7.services_.end() && key_it != key->services_.end(); ++k7_it, ++key_it) {
      EXPECT_EQ(k7_it->first, key_it->first);

      Service *k7_s = k7_it->second.get();
      Service *key_s = key_it->second.get();

      (this->*(kVerifyServices.at(k7_it->first)))(k7_s, key_s);
    }
  }

  // Verifies deterministic generation and round-trip parsing of a token.
  void VerifyAccessToken2(const std::string &expected, AccessToken2 *key) {
    std::string result = key->Build();
    EXPECT_EQ(expected, result);

    if (expected.empty()) {
      return;
    }

    VerifyParsedAccessToken2(result, key);
  }

  // Tests RTC token generation and parsing with an integer UID.
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

  // Tests RTC token generation and parsing with the wildcard integer UID.
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

  // Tests RTC token generation and parsing with a string UID.
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

  // Tests RTM token generation and parsing.
  void TestAccessToken2Rtm() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceRtm(account_));
    service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire_);

    key.AddService(std::move(service));

    std::string expected =
        "007eJxTYEhuZrAR/XT+XPihI+6t4t5F9RtUltw9em3Pwi2sr6P/"
        "lAspMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJiBmBP"
        "O5GIwsLIyMTQyNzI0BndAdKg==";

    VerifyAccessToken2(expected, &key);
  }

  // Tests a Chat token with user-level privileges.
  void TestAccessToken2ChatUser() {
    AccessToken2 key(app_id_, app_certificate_, issue_ts_, expire_);
    key.salt_ = 1;

    std::unique_ptr<Service> service(new ServiceChat(account_));
    service->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);

    key.AddService(std::move(service));

    std::string expected =
        "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/"
        "Vzz+"
        "p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCO"
        "ZzMRhZWBgZmxgamRsDAB+lHrg=";

    VerifyAccessToken2(expected, &key);
  }

  // Tests a Chat token with app-level privileges.
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

  // Tests an APaaS room-user token combined with RTM and Chat services.
  void TestAccessToken2ApaasRoomUser() {
    MD5 h{account_};
    std::string char_user_id = h.toStr();

    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> apaas_service(new ServiceApaas(room_uuid_, account_, role_));
    apaas_service->AddPrivilege(ServiceApaas::kPrivilegeRoomUser, expire_);
    token.AddService(std::move(apaas_service));

    std::unique_ptr<Service> rtm_service(new ServiceRtm(account_));
    rtm_service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire_);
    token.AddService(std::move(rtm_service));

    std::unique_ptr<Service> chat_service(new ServiceChat(char_user_id));
    chat_service->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);
    token.AddService(std::move(chat_service));

    std::string expected =
        "007eJxTYOi6fYVB7qlA2ZWQ+Ko3N2IafQOddj+"
        "K4tjh3PS7P2vx4a0KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYG"
        "BgYGRgYmBmYgDQjmM/"
        "FYGRhYWRsYmhkbswKF1VgMDMwMza2MDYxskg0NktLSjROSzIzMDZISk1OszCwNEllh6tlZ"
        "jA0MkY2hpEBANqIKYQ=";

    VerifyAccessToken2(expected, &token);
  }

  // Tests an APaaS token with user-level privileges.
  void TestAccessToken2ApaasUser() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> apaas_service(new ServiceApaas("", account_));
    apaas_service->AddPrivilege(ServiceApaas::kPrivilegeUser, expire_);
    token.AddService(std::move(apaas_service));

    std::string expected =
        "007eJxTYEg4e9Zj9gch+"
        "QkfFi1qM7tdkn1G3Kzt6FTJpTpzRQ4brixTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI"
        "0NTAzTDI2dv8iwBDBxMDAyADC7EDMBOYzMHAxGFlYGBmbGBqZG///DwDuNR56";

    VerifyAccessToken2(expected, &token);
  }

  // Tests an APaaS token with app-level privileges.
  void TestAccessToken2ApaasApp() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> apaas_service(new ServiceApaas());
    apaas_service->AddPrivilege(ServiceApaas::kPrivilegeApp, expire_);
    token.AddService(std::move(apaas_service));

    std::string expected =
        "007eJxTYJgT3rumdJdoWJpC3aNTb4o76swyLsrHvmznOn/"
        "x1cQM9gcKDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGUCYH"
        "YiZwXwQ+P8fAADUHTQ=";

    VerifyAccessToken2(expected, &token);
  }

  // Tests generation and parsing of a token containing different service types.
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

    std::unique_ptr<Service> fpa(new ServiceFpa());
    fpa->AddPrivilege(ServiceFpa::kPrivilegeLogin, expire_);

    std::unique_ptr<Service> chat(new ServiceChat(account_));
    chat->AddPrivilege(ServiceChat::kPrivilegeUser, expire_);

    key.AddService(std::move(rtc));
    key.AddService(std::move(rtm));
    key.AddService(std::move(fpa));
    key.AddService(std::move(chat));

    std::string expected =
        "007eJxTYLjhFiNy2/+8zqRJj20tt73SKA2e3/"
        "joPVv4761qZnrOyqYKDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKY"
        "GBgYGRgYWIAkCIP4TGCSGUyygEkFBvMUcyNjM9PUJEsLYxMLU2NL81TjVOM0yxQTM4OklJ"
        "RELgYjCwsjYxNDI3NjJqA5EJM4GUpSi0viS4tTi1jggqxwFrImAAIiLHc=";

    VerifyAccessToken2(expected, &key);
  }

  // Tests byte-level compatibility with Streaming, FCDN, and RTM2 from the xuyang branch.
  void TestXuyangExtendedServicesCompatibility() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> streaming(new ServiceStreaming(channel_name_, account_));
    streaming->AddPrivilege(ServiceStreaming::kPrivilegePublishMixStream, expire_);
    streaming->AddPrivilege(ServiceStreaming::kPrivilegePublishRawStream, expire_);
    token.AddService(std::move(streaming));

    std::unique_ptr<Service> fcdn(new ServiceFCdn(channel_name_, account_));
    fcdn->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);
    fcdn->AddPrivilege(ServiceFCdn::kPrivilegePlay, expire_);
    token.AddService(std::move(fcdn));

    ServiceRtm2::Permissions permissions;
    permissions.Add(ServiceRtm2::Permissions::kMessageChannels, ServiceRtm2::Permissions::kRead, {"message-a", "message-b"});
    permissions.Add(ServiceRtm2::Permissions::kStreamChannels, ServiceRtm2::Permissions::kWrite, {"stream-a"});
    permissions.Add(ServiceRtm2::Permissions::kUsers, ServiceRtm2::Permissions::kRead, {"user-a"});

    std::unique_ptr<Service> rtm2(new ServiceRtm2(user_id_, permissions));
    rtm2->AddPrivilege(ServiceRtm2::kPrivilegeLogin, expire_);
    token.AddService(std::move(rtm2));

    const std::string xuyang_token =
        "007eJxTYPj86Lzdz79M25wNn/lMfvu+TkfmdpiviKvChm8ZV3SWndytwGBpbuDsaGyakmpmkGxiYmZimpSUmGqRaGRoamBmmGRs7P5FgCGCiYGBkYGBgRkI"
        "mYAsEJ8JTCowmKeYGxmbmaYmWVoYm1iYGluapxqnGqdZppiYGSSlpCRyMRhZWBgZmxgamRuzUaSbA6gXopuToSS1uCS+tDi1iJkB4jQmoGBuanFxYnqqbiKCmcTIAIEcDMUl"
        "RamJubqJLGD1jAxsDCD9uokAO/VDvQ==";

    VerifyAccessToken2(xuyang_token, &token);
  }

  // Tests deterministic generation and UID conversion for Streaming and FCDN services.
  void TestExtendedServiceUidConversion() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> streaming_uid(new ServiceStreaming(channel_name_, uid_));
    streaming_uid->AddPrivilege(ServiceStreaming::kPrivilegePublishMixStream, expire_);
    token.AddService(std::move(streaming_uid));

    std::unique_ptr<Service> streaming_wildcard(new ServiceStreaming(channel_name_, 0));
    streaming_wildcard->AddPrivilege(ServiceStreaming::kPrivilegePublishRawStream, expire_);
    token.AddService(std::move(streaming_wildcard));

    std::unique_ptr<Service> streaming_account(new ServiceStreaming(channel_name_, "stream-account"));
    streaming_account->AddPrivilege(ServiceStreaming::kPrivilegePublishMixStream, expire_);
    streaming_account->AddPrivilege(ServiceStreaming::kPrivilegePublishRawStream, expire_);
    token.AddService(std::move(streaming_account));

    std::unique_ptr<Service> fcdn_uid(new ServiceFCdn(channel_name_, uid_));
    fcdn_uid->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);
    token.AddService(std::move(fcdn_uid));

    std::unique_ptr<Service> fcdn_wildcard(new ServiceFCdn(channel_name_, 0));
    fcdn_wildcard->AddPrivilege(ServiceFCdn::kPrivilegePlay, expire_);
    token.AddService(std::move(fcdn_wildcard));

    std::unique_ptr<Service> fcdn_account(new ServiceFCdn(channel_name_, "fcdn-account"));
    fcdn_account->AddPrivilege(ServiceFCdn::kPrivilegePublish, expire_);
    fcdn_account->AddPrivilege(ServiceFCdn::kPrivilegePlay, expire_);
    token.AddService(std::move(fcdn_account));

    const std::string expected_token =
        "007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X";
    const std::string generated_token = token.Build();
    EXPECT_EQ(expected_token, generated_token);

    AccessToken2 parsed;
    ASSERT_TRUE(parsed.FromString(generated_token));
    ASSERT_EQ(kTokenVerifySuccess, parsed.VerifySignature(app_certificate_));
    ASSERT_EQ(3, parsed.services_.count(ServiceStreaming::kServiceType));
    ASSERT_EQ(3, parsed.services_.count(ServiceFCdn::kServiceType));

    auto streaming_range = parsed.services_.equal_range(ServiceStreaming::kServiceType);
    auto streaming_it = streaming_range.first;
    auto *parsed_streaming_uid = dynamic_cast<ServiceStreaming *>(streaming_it->second.get());
    auto *parsed_streaming_wildcard = dynamic_cast<ServiceStreaming *>((++streaming_it)->second.get());
    auto *parsed_streaming_account = dynamic_cast<ServiceStreaming *>((++streaming_it)->second.get());
    ASSERT_NE(nullptr, parsed_streaming_uid);
    ASSERT_NE(nullptr, parsed_streaming_wildcard);
    ASSERT_NE(nullptr, parsed_streaming_account);
    EXPECT_EQ(channel_name_, parsed_streaming_uid->channel_name_);
    EXPECT_EQ(account_, parsed_streaming_uid->account_);
    EXPECT_EQ(expire_, parsed_streaming_uid->privileges_.at(ServiceStreaming::kPrivilegePublishMixStream));
    EXPECT_EQ(channel_name_, parsed_streaming_wildcard->channel_name_);
    EXPECT_EQ("", parsed_streaming_wildcard->account_);
    EXPECT_EQ(expire_, parsed_streaming_wildcard->privileges_.at(ServiceStreaming::kPrivilegePublishRawStream));
    EXPECT_EQ(channel_name_, parsed_streaming_account->channel_name_);
    EXPECT_EQ("stream-account", parsed_streaming_account->account_);
    EXPECT_EQ(expire_, parsed_streaming_account->privileges_.at(ServiceStreaming::kPrivilegePublishMixStream));
    EXPECT_EQ(expire_, parsed_streaming_account->privileges_.at(ServiceStreaming::kPrivilegePublishRawStream));

    auto fcdn_range = parsed.services_.equal_range(ServiceFCdn::kServiceType);
    auto fcdn_it = fcdn_range.first;
    auto *parsed_fcdn_uid = dynamic_cast<ServiceFCdn *>(fcdn_it->second.get());
    auto *parsed_fcdn_wildcard = dynamic_cast<ServiceFCdn *>((++fcdn_it)->second.get());
    auto *parsed_fcdn_account = dynamic_cast<ServiceFCdn *>((++fcdn_it)->second.get());
    ASSERT_NE(nullptr, parsed_fcdn_uid);
    ASSERT_NE(nullptr, parsed_fcdn_wildcard);
    ASSERT_NE(nullptr, parsed_fcdn_account);
    EXPECT_EQ(channel_name_, parsed_fcdn_uid->channel_name_);
    EXPECT_EQ(account_, parsed_fcdn_uid->account_);
    EXPECT_EQ(expire_, parsed_fcdn_uid->privileges_.at(ServiceFCdn::kPrivilegePublish));
    EXPECT_EQ(channel_name_, parsed_fcdn_wildcard->channel_name_);
    EXPECT_EQ("", parsed_fcdn_wildcard->account_);
    EXPECT_EQ(expire_, parsed_fcdn_wildcard->privileges_.at(ServiceFCdn::kPrivilegePlay));
    EXPECT_EQ(channel_name_, parsed_fcdn_account->channel_name_);
    EXPECT_EQ("fcdn-account", parsed_fcdn_account->account_);
    EXPECT_EQ(expire_, parsed_fcdn_account->privileges_.at(ServiceFCdn::kPrivilegePublish));
    EXPECT_EQ(expire_, parsed_fcdn_account->privileges_.at(ServiceFCdn::kPrivilegePlay));

    const std::vector<std::string> cross_language_tokens = {
        // Go compress/flate.
        "007eJxSYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwMzAyMIL5CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxiB9TETqY2BgZmCC2kKsHj6G4pKi1MRc3cTk5PzSvBI2Mt3JRpI72Uh2Jw9DWnJKHsyVgAAAAP//SW9fVw==",
        // Node.js zlib.
        "007eJxTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwMzAyMIL5CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxiB9TETqY2BgZmCC2kKsHj6G4pKi1MRc3cTk5PzSvBI2Mt3JRpI72Uh2Jw9DWnJKHsyVAElvX1c=",
        // C# SharpZipLib.
        "007eJydjjsKwkAURZ8RUogEEdE2ha2QzJtfKhELwQ1oYTOTGW38gJ/SNYhFsLJTXIilS8gKbKxcgB+0N1aXWxzO8SE9dffl0Xi3btqjrl966aF6TWrbwc07V7qbhPgQiaDdQmYsD2JKOWVaKysVCVnAQ43YuZeg7wDkAMCF/HNz7++DMIIgZ1ZHEqlkGAmLFoeRoTzQxqgCECkJ0pAIfHHOjxw8Lc7H8ivjwWI5t2rSUHE8W02X7p+dbqZON3NnEYaxmX4rH0lvX1c=",
        // Dart archive.
        "007eAFTYLi93GuuUHrO9Fr71KVJKqfDby8RezlVfGLMO77DIl79U40UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMjAwsDEwA2lGMF+BwTzF3MjYzDQ1ydLC2MTC1NjSPNU41TjNMsXEzCApJSWRi8HIwsLI2MTQyNwYpI+JSH0MQFuYoLYQq4ePobikKDUxVzcxOTm/NK+EjUx3spHkTjaS3cnDkJackgdzJQBJb19X",
        // Rust flate2.
        "007eJydjjsOAVEYRn8jmUJERIR2Cq1k5v73NZWIQmIDFJp7514aj8SjtAZRiEpHLERpCbMCjcoCDKGfUX35ipNzPIgvvWNlPDlsWvasG7d+fKrd9/Xd8FG6VnvbPfEgFH6njcxY7keUcsq0VlYqEjCfBxqx+yzDwAHIAYAL+WRzn++BMIIgZ1aHEqlkGAqLFkehodzXxqgCECkJ0oAIfHNOSg4Si/O1pGVKsFwtrJo2VRTN17OV+2enm6nTzdxZhFFkZr/KF0lvX1c=",
    };
    for (const auto &cross_language_token : cross_language_tokens) {
      VerifyParsedAccessToken2(cross_language_token, &token);
    }
  }

  // Tests generation, parsing, and verification with duplicate service types.
  void TestSameServiceMulti() {
    auto rtc_expire = expiredTs_;
    auto rtm_expire = expiredTs_ + 100;
    auto rtm_stream_expire = expiredTs_ + 200;

    AccessToken2 token(app_id_, app_certificate_, 0, rtc_expire);

    token.AddService(std::move(BuildRtcService(channel_name_, uid_, rtc_expire)));
    token.AddService(std::move(BuildRtmService(account_, rtm_expire)));
    token.AddService(std::move(BuildRtmStreamServiceAsRtc(channel_name_, uid_, rtm_stream_expire)));
    std::string token_str = token.Build();
    AccessToken2 token_parsed;
    ASSERT_EQ(token_parsed.VerifySignature(app_certificate_), kTokenInvalid);
    ASSERT_TRUE(token_parsed.FromString(token_str));
    ASSERT_EQ(token_parsed.VerifySignature(app_certificate_+"123"), kTokenInvalidInfo);
    std::string err_cert = app_certificate_;
    err_cert[0] = '1';
    ASSERT_EQ(token_parsed.VerifySignature(err_cert), kTokenVerifyFailed);
    ASSERT_EQ(token_parsed.VerifySignature(app_certificate_), kTokenVerifySuccess);

    EXPECT_EQ(app_id_, token.app_id_);
    EXPECT_EQ(rtc_expire, token.expire_);

    ASSERT_EQ(3, token.services_.size());
    ASSERT_EQ(token.services_.count(ServiceRtc::kServiceType), 2);
    ASSERT_EQ(token.services_.count(ServiceRtm::kServiceType), 1);

    
    uint32_t cnt = 0;
    for (auto srv = token_parsed.services_.begin(); srv != token_parsed.services_.end(); srv++) {
        if (srv->first == ServiceRtc::kServiceType) {
            if (cnt == 0 ) {
                ServiceRtc *rtc = dynamic_cast<ServiceRtc *>(srv->second.get());
                EXPECT_EQ(rtc->channel_name_, channel_name_);
                EXPECT_EQ(rtc->account_, account_);
                EXPECT_EQ(rtc->privileges_[ServiceRtc::kPrivilegeJoinChannel], rtc_expire);
                EXPECT_EQ(rtc->privileges_[ServiceRtc::kPrivilegePublishAudioStream], rtc_expire);
                EXPECT_EQ(rtc->privileges_[ServiceRtc::kPrivilegePublishVideoStream], rtc_expire);
                EXPECT_EQ(rtc->privileges_[ServiceRtc::kPrivilegePublishDataStream], rtc_expire);
            } else if (cnt == 1) {
                ServiceRtc *rtm_stream = dynamic_cast<ServiceRtc *>(srv->second.get());
                EXPECT_EQ(rtm_stream->channel_name_, channel_name_);
                EXPECT_EQ(rtm_stream->account_, account_);
                EXPECT_EQ(rtm_stream->privileges_[ServiceRtc::kPrivilegeJoinChannel], rtm_stream_expire);
                EXPECT_EQ(rtm_stream->privileges_[ServiceRtc::kPrivilegePublishDataStream], rtm_stream_expire);
            }
            cnt++;
        } else if (srv->first == ServiceRtm::kServiceType) {
            ServiceRtm * rtm = dynamic_cast<ServiceRtm *>(srv->second.get());
            EXPECT_EQ(rtm->user_id_, account_);
            EXPECT_EQ(rtm->privileges_[ServiceRtm::kPrivilegeLogin], rtm_expire);
        } else {
            EXPECT_TRUE(false);
        }
    }
    EXPECT_EQ(token_parsed.GenerateSignature(app_certificate_), token_parsed.signature_);
  }

  // Tests parsing and verification of a token generated by the previous implementation.
  void TestOldTokenParse() {
    std::string token_str = "007eJxTYLjhFiNy2/+8zqRJj20tt73SKA2e3/"
        "joPVv4761qZnrOyqYKDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKY"
        "GBgYGRgYWIAkCIP4TGCSGUyygEkFBvMUcyNjM9PUJEsLYxMLU2NL81TjVOM0yxQTM4OklJ"
        "RELgYjCwsjYxNDI3NjJqA5EJM4GUpSi0viS4tTi1jggqxwFrImAAIiLHc=";
    AccessToken2 token_parsed;
    ASSERT_TRUE(token_parsed.FromString(token_str));
    ASSERT_EQ(token_parsed.VerifySignature(app_certificate_), kTokenVerifySuccess);
    EXPECT_EQ(token_parsed.app_id_, app_id_);
    EXPECT_EQ(token_parsed.expire_, expire_);
    EXPECT_EQ(token_parsed.GenerateSignature(app_certificate_), token_parsed.signature_);
    VerifyAccessToken2(token_str, &token_parsed);
  }

  // Keeps known services parsed before an unknown ServiceType.
  void TestUnknownServiceAfterKnownService() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> rtc(new ServiceRtc(channel_name_, uid_));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);
    token.AddService(std::move(rtc));

    std::unique_ptr<Service> unknown(new UnknownService(999));
    unknown->AddPrivilege(1, expire_);
    token.AddService(std::move(unknown));

    AccessToken2 parsed;
    ASSERT_TRUE(parsed.FromString(token.Build()));
    ASSERT_EQ(kTokenVerifySuccess, parsed.VerifySignature(app_certificate_));
    ASSERT_EQ(1, parsed.services_.size());
    ASSERT_EQ(1, parsed.services_.count(ServiceRtc::kServiceType));
    ASSERT_EQ(0, parsed.services_.count(999));

    auto *parsed_rtc = dynamic_cast<ServiceRtc *>(parsed.services_.begin()->second.get());
    ASSERT_NE(nullptr, parsed_rtc);
    EXPECT_EQ(channel_name_, parsed_rtc->channel_name_);
    EXPECT_EQ(account_, parsed_rtc->account_);
    EXPECT_EQ(expire_, parsed_rtc->privileges_[ServiceRtc::kPrivilegeJoinChannel]);
  }

  // Stops safely before known services that follow an unknown ServiceType payload.
  void TestUnknownServiceBeforeKnownService() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;

    std::unique_ptr<Service> unknown(new UnknownService(0));
    unknown->AddPrivilege(1, expire_);
    token.AddService(std::move(unknown));

    std::unique_ptr<Service> rtc(new ServiceRtc(channel_name_, uid_));
    rtc->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, expire_);
    token.AddService(std::move(rtc));

    AccessToken2 parsed;
    ASSERT_TRUE(parsed.FromString(token.Build()));
    ASSERT_EQ(kTokenVerifySuccess, parsed.VerifySignature(app_certificate_));
    EXPECT_TRUE(parsed.services_.empty());
  }

  // Rejects signature verification after a later token parse fails.
  void TestFailedParseClearsVerificationState() {
    AccessToken2 token(app_id_, app_certificate_, issue_ts_, expire_);
    token.salt_ = 1;
    token.AddService(std::move(BuildRtcService(channel_name_, uid_, expire_)));

    AccessToken2 parsed;
    ASSERT_TRUE(parsed.FromString(token.Build()));
    ASSERT_EQ(kTokenVerifySuccess, parsed.VerifySignature(app_certificate_));

    ASSERT_FALSE(parsed.FromString("006invalid"));
    EXPECT_EQ(kTokenInvalid, parsed.VerifySignature(app_certificate_));
    EXPECT_TRUE(parsed.services_.empty());
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
  uint32_t expiredTs_;
  int16_t role_;
};

// Tests RTC token behavior with an integer UID.
TEST_F(AccessToken2_test, testAccessToken2WithIntUid) { TestAccessToken2WithIntUid(); }

// Tests RTC token behavior with the wildcard integer UID.
TEST_F(AccessToken2_test, testAccessToken2WithIntUidZero) { TestAccessToken2WithIntUidZero(); }

// Tests RTC token behavior with a string UID.
TEST_F(AccessToken2_test, testAccessToken2WithStringUid) { TestAccessToken2WithStringUid(); }

// Tests RTM token generation and parsing.
TEST_F(AccessToken2_test, testAccessToken2Rtm) { TestAccessToken2Rtm(); }

// Tests a Chat token with user-level privileges.
TEST_F(AccessToken2_test, testAccessToken2ChatUser) { TestAccessToken2ChatUser(); }

// Tests a Chat token with app-level privileges.
TEST_F(AccessToken2_test, testAccessToken2ChatApp) { TestAccessToken2ChatApp(); }

// Tests an APaaS room-user token combined with RTM and Chat services.
TEST_F(AccessToken2_test, testAccessToken2ApaasRoomUser) { TestAccessToken2ApaasRoomUser(); }

// Tests an APaaS token with user-level privileges.
TEST_F(AccessToken2_test, testAccessToken2ApaasUser) { TestAccessToken2ApaasUser(); }

// Tests an APaaS token with app-level privileges.
TEST_F(AccessToken2_test, testAccessToken2ApaasApp) { TestAccessToken2ApaasApp(); }

// Tests a token containing different service types.
TEST_F(AccessToken2_test, testAccessToken2WithMultiService) { TestAccessToken2WithMultiService(); }

// Tests byte-level compatibility with the extended services from the xuyang branch.
TEST_F(AccessToken2_test, testXuyangExtendedServicesCompatibility) { TestXuyangExtendedServicesCompatibility(); }

// Tests numeric and wildcard user IDs for Streaming and FCDN services.
TEST_F(AccessToken2_test, testExtendedServiceUidConversion) { TestExtendedServiceUidConversion(); }

// Tests a token containing duplicate service types.
TEST_F(AccessToken2_test, testSameServiceMulti) { TestSameServiceMulti(); }

// Tests backward-compatible parsing of a token from the previous implementation.
TEST_F(AccessToken2_test, testOldTokenParse) { TestOldTokenParse(); }

// Tests parsing when an unknown service follows a known service.
TEST_F(AccessToken2_test, testUnknownServiceAfterKnownService) { TestUnknownServiceAfterKnownService(); }

// Tests parsing when an unknown service precedes a known service.
TEST_F(AccessToken2_test, testUnknownServiceBeforeKnownService) { TestUnknownServiceBeforeKnownService(); }

// Tests that a failed parse invalidates an earlier successful parse.
TEST_F(AccessToken2_test, testFailedParseClearsVerificationState) { TestFailedParseClearsVerificationState(); }
