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
 public:
  Service(uint16_t type) { type_ = type; }

  virtual ~Service() = default;

  uint16_t ServiceType() { return type_; }

  void AddPrivilege(uint16_t privilege, uint32_t expire) {
    privileges_[privilege] = expire;
  }

  virtual std::string PackService() = 0;

  virtual void UnpackService(Unpacker *unpacker) = 0;

  virtual std::unique_ptr<Service> Clone() const = 0;

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

 public:
  uint16_t type_;
  std::map<uint16_t, uint32_t> privileges_;

 protected:
  Service(const Service &) = default;
  Service(Service &&) = default;
  Service &operator=(const Service &) = default;
  Service &operator=(Service &&) = default;
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

  virtual std::unique_ptr<Service> Clone() const override {
    return std::unique_ptr<Service>(new ServiceRtc(*this));
  }

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

 public:
  std::string channel_name_;
  std::string account_;

 protected:
  ServiceRtc(const ServiceRtc &) = default;
  ServiceRtc(ServiceRtc &&) = default;
  ServiceRtc &operator=(const ServiceRtc &) = default;
  ServiceRtc &operator=(ServiceRtc &&) = default;
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

  virtual std::unique_ptr<Service> Clone() const override {
    return std::unique_ptr<Service>(new ServiceRtm(*this));
  }

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

 public:
  std::string user_id_;

 protected:
  ServiceRtm(const ServiceRtm &) = default;
  ServiceRtm(ServiceRtm &&) = default;
  ServiceRtm &operator=(const ServiceRtm &) = default;
  ServiceRtm &operator=(ServiceRtm &&) = default;
};

class ServiceFpa : public Service {
 public:
  enum {
    kServiceType = 4,

    kPrivilegeLogin = 1,
  };

  ServiceFpa() : Service(kServiceType) {}

  virtual std::string PackService() override { return Pack(this); }
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  virtual std::unique_ptr<Service> Clone() const override {
    return std::unique_ptr<Service>(new ServiceFpa(*this));
  }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceFpa *x) {
    return p << dynamic_cast<const Service *>(x);
  }
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceFpa *x) {
    return p >> dynamic_cast<Service *>(x);
  }

 protected:
  ServiceFpa(const ServiceFpa &) = default;
  ServiceFpa(ServiceFpa &&) = default;
  ServiceFpa &operator=(const ServiceFpa &) = default;
  ServiceFpa &operator=(ServiceFpa &&) = default;
};

class ServiceChat : public Service {
 public:
  enum {
    kServiceType = 5,

    kPrivilegeUser = 1,
    kPrivilegeApp = 2,
  };

 public:
  ServiceChat(const std::string &user_id = "")
      : Service(kServiceType), user_id_(user_id) {}

  virtual std::string PackService() override { return Pack(this); }

  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  virtual std::unique_ptr<Service> Clone() const override {
    return std::unique_ptr<Service>(new ServiceChat(*this));
  }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceChat *x) {
    p << dynamic_cast<const Service *>(x) << x->user_id_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceChat *x) {
    p >> dynamic_cast<Service *>(x) >> x->user_id_;
    return p;
  }

 public:
  std::string user_id_;
};

class ServiceEducation : public Service {
 public:
  enum {
    kServiceType = 7,

    kPrivilegeRoomUser = 1,
    kPrivilegeUser = 2,
    kPrivilegeApp = 3,
  };

 public:
  ServiceEducation(const std::string &room_uuid = "",
                   const std::string &user_uuid = "", int16_t role = -1)
      : Service(kServiceType),
        room_uuid_(room_uuid),
        user_uuid_(user_uuid),
        role_(role) {}

  virtual std::string PackService() override { return Pack(this); }

  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  virtual std::unique_ptr<Service> Clone() const override {
    return std::unique_ptr<Service>(new ServiceEducation(*this));
  }

  friend agora::tools::Packer &operator<<(agora::tools::Packer &p,
                                          const ServiceEducation *x) {
    p << dynamic_cast<const Service *>(x) << x->room_uuid_ << x->user_uuid_
      << x->role_;
    return p;
  }

  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p,
                                            ServiceEducation *x) {
    p >> dynamic_cast<Service *>(x) >> x->room_uuid_ >> x->user_uuid_ >>
        x->role_;
    return p;
  }

 public:
  std::string room_uuid_;
  std::string user_uuid_;
  int16_t role_;
};

template <class T>
struct ServiceCreator {
  static Service *New() { return (new T()); }
};
static const std::map<uint16_t, Service *(*)()> kServiceCreator = {
    {ServiceRtc::kServiceType, ServiceCreator<ServiceRtc>::New},
    {ServiceRtm::kServiceType, ServiceCreator<ServiceRtm>::New},
    {ServiceFpa::kServiceType, ServiceCreator<ServiceFpa>::New},
    {ServiceChat::kServiceType, ServiceCreator<ServiceChat>::New},
    {ServiceEducation::kServiceType, ServiceCreator<ServiceEducation>::New},
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
    auto signing_info = SigningInfo();
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
      unpacker >> signature_ >> app_id_ >> issue_ts_ >> expire_ >> salt_;
      UnpackServices(&unpacker);
    } catch (std::exception &e) {
      return false;
    }
    return true;
  }

  std::string GenerateSignature(const std::string &app_certificate) {
    app_cert_ = app_certificate;
    if (!BuildCheck()) return "";

    auto signing = Signing();
    auto signing_info = SigningInfo();
    auto signature = HmacSign2(signing, signing_info, HMAC_SHA256_LENGTH);
    return signature;
  }

  std::string Signing() {
    std::string signing;
    signing = HmacSign2(Pack(issue_ts_), app_cert_, HMAC_SHA256_LENGTH);
    signing = HmacSign2(Pack(salt_), signing, HMAC_SHA256_LENGTH);
    return signing;
  }

  std::string SigningInfo() {
    auto signing_info = Pack(app_id_) + Pack(issue_ts_) + Pack(expire_) +
                        Pack(salt_) + PackServices();
    return signing_info;
  }

  std::string PackServices() {
    auto services = Pack(static_cast<uint16_t>(services_.size()));
    for (auto it = services_.begin(); it != services_.end(); ++it) {
      services += it->second->PackService();
    }
    return services;
  }

  void UnpackServices(Unpacker *unpacker) {
    uint16_t service_count;
    *unpacker >> service_count;

    services_.clear();
    for (auto i = 0; i < service_count; ++i) {
      uint16_t service_type;
      *unpacker >> service_type;

      auto service =
          std::unique_ptr<Service>(kServiceCreator.at(service_type)());
      service->UnpackService(unpacker);
      services_[service_type] = std::move(service);
    }
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

 public:
  uint32_t issue_ts_;
  uint32_t expire_;
  uint32_t salt_;

  std::string app_id_;
  std::string app_cert_;
  std::string signature_;

  std::map<uint16_t, std::unique_ptr<Service>> services_;
};

}  // namespace tools
}  // namespace agora
