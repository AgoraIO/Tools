// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <zlib.h>

#include <map>
#include <memory>
#include <string>

#include "cpp/src/Packer.h"
#include "cpp/src/utils.h"

namespace agora {
namespace tools {

class Service {
 protected:
  Service(uint16_t type) { type_ = type; }

  virtual ~Service() = default;

 public:
  uint16_t ServiceType() { return type_; }

  void AddPrivilege(uint16_t privilege, uint32_t expire) {
    privileges_[privilege] = expire;
  }

  virtual std::string PackService() = 0;

  virtual void UnpackService(Unpacker *unpacker) = 0;

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const Service *x) {
    p << x->type_ << x->privileges_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            Service *x) {
    p >> x->privileges_;
    return p;
  }

 protected:
  uint16_t type_;
  std::map<uint16_t, uint32_t> privileges_;

 private:
  Service(const Service &) = delete;
  Service(Service &&) = delete;
  Service &operator=(const Service &) = delete;
  Service &operator=(Service &&) = delete;
};

class ServiceRtc : public Service {
 public:
  enum {
    kServiceType = 1,

    kPrivilegeJoinChannel = 1,
    kPrivilegePublishAudioStream = 2,
    kPrivilegePublishVideoStream = 3,
    kPrivilegePublishDataStream = 4,
  };

 public:
  ServiceRtc(const std::string &channel_name = "", uint32_t uid = 0)
      : Service(kServiceType), channel_name_(channel_name) {
    if (uid == 0) {
      account_ = "";
    } else {
      account_ = std::to_string(uid);
    }
  }

  ServiceRtc(const std::string &channel_name, const std::string &account)
      : Service(kServiceType), channel_name_(channel_name), account_(account) {}

  virtual std::string PackService() override { return Pack(this); }

  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceRtc *x) {
    p << dynamic_cast<const Service *>(x) << x->channel_name_ << x->account_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceRtc *x) {
    p >> dynamic_cast<Service *>(x) >> x->channel_name_ >> x->account_;
    return p;
  }

 private:
  std::string channel_name_;
  std::string account_;
};

class ServiceRtm : public Service {
 public:
  enum {
    kServiceType = 2,

    kPrivilegeLogin = 1,
  };

 public:
  ServiceRtm(const std::string &user_id = "")
      : Service(kServiceType), user_id_(user_id) {}

  virtual std::string PackService() override { return Pack(this); }

  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceRtm *x) {
    p << dynamic_cast<const Service *>(x) << x->user_id_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceRtm *x) {
    p >> dynamic_cast<Service *>(x) >> x->user_id_;
    return p;
  }

 private:
  std::string user_id_;
};

class ServiceStreaming : public Service {
 public:
  enum {
    kServiceType = 3,

    kPrivilegePublishMixStream = 1,
    kPrivilegePublishRawStream = 2,
  };

 public:
  ServiceStreaming(const std::string &channel_name = "", uint32_t uid = 0)
      : Service(kServiceType), channel_name_(channel_name) {
    if (uid == 0) {
      account_ = "";
    } else {
      account_ = std::to_string(uid);
    }
  }

  ServiceStreaming(const std::string &channel_name, const std::string &account)
      : Service(kServiceType), channel_name_(channel_name), account_(account) {}

  virtual std::string PackService() override { return Pack(this); }

  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceStreaming *x) {
    p << dynamic_cast<const Service *>(x) << x->channel_name_ << x->account_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceStreaming *x) {
    p >> dynamic_cast<Service *>(x) >> x->channel_name_ >> x->account_;
    return p;
  }

 private:
  std::string channel_name_;
  std::string account_;
};

template <class T>
struct ServiceCreator {
  static Service *New() { return (new T()); }
};
static const std::map<uint16_t, Service *(*)()> kServiceCreator = {
    {ServiceRtc::kServiceType, ServiceCreator<ServiceRtc>::New},
    {ServiceRtm::kServiceType, ServiceCreator<ServiceRtm>::New},
    {ServiceStreaming::kServiceType, ServiceCreator<ServiceStreaming>::New},
};

class AccessToken2 {
 public:
  AccessToken2(const std::string &app_id = "",
               const std::string &app_certificate = "", uint32_t issue_ts = 0,
               uint32_t expire = 900)
      : app_id_(app_id), app_cert_(app_certificate) {
    if (issue_ts != 0) {
      issue_ts_ = issue_ts;
    } else {
      issue_ts_ = ::time(NULL);
    }

    expire_ = expire;
    salt_ = GenerateSalt();
  }

  static std::string Version() { return "007"; }

  void AddService(std::unique_ptr<Service> service) {
    services_[service->ServiceType()] = std::move(service);
  }

  std::string Build() {
    if (!BuildCheck()) return "";

    auto signing = Signing();
    auto signing_info = Pack(app_id_) + Pack(issue_ts_) + Pack(expire_) +
                        Pack(salt_) +
                        Pack(static_cast<uint16_t>(services_.size()));
    for (auto it = services_.begin(); it != services_.end(); ++it) {
      signing_info += it->second->PackService();
    }

    auto signature = Pack(HmacSign2(signing, signing_info, HMAC_SHA256_LENGTH));
    auto compressed = Compress(signature + signing_info);
    return Version() + base64Encode(compressed);
  }

  bool FromString(const std::string &token) {
    if (token.substr(0, VERSION_LENGTH) != Version()) {
      return false;
    }

    try {
      auto buffer = Decompress(base64Decode(token.substr(VERSION_LENGTH)));
      Unpacker unpacker(buffer.data(), buffer.length());

      uint16_t service_count;
      std::string signature;
      unpacker >> signature >> app_id_ >> issue_ts_ >> expire_ >> salt_ >>
          service_count;

      services_.clear();
      for (auto i = 0; i < service_count; ++i) {
        uint16_t service_type;
        unpacker >> service_type;
        auto service =
            std::unique_ptr<Service>(kServiceCreator.at(service_type)());
        service->UnpackService(&unpacker);
        services_[service_type] = std::move(service);
      }
    } catch (std::exception &e) {
      return false;
    }
    return true;
  }

 private:
  std::string Signing() {
    std::string signing;
    signing = HmacSign2(Pack(issue_ts_), app_cert_, HMAC_SHA256_LENGTH);
    signing = HmacSign2(Pack(salt_), signing, HMAC_SHA256_LENGTH);
    return signing;
  }

  bool BuildCheck() {
    if (!IsUUID(app_id_)) {
      perror("invalid appID");
      return false;
    }

    if (!IsUUID(app_cert_)) {
      perror("invalid appCertificate");
      return false;
    }

    if (services_.empty()) {
      perror("invalid service privilege");
      return false;
    }

    return true;
  }

 private:
  uint32_t issue_ts_;
  uint32_t expire_;
  uint32_t salt_;

  std::string app_id_;
  std::string app_cert_;

  std::map<uint16_t, std::unique_ptr<Service>> services_;
};

}  // namespace tools
}  // namespace agora
