// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <zlib.h>

#include <map>
#include <memory>
#include <string>
#include <vector>

#include "cpp/src/Packer.h"
#include "cpp/src/utils.h"

namespace agora {
namespace tools {

class Service {
 public:
  // Creates a service with the specified service type.
  Service(uint16_t type) { type_ = type; }

  // Destroys the service through the base-class interface.
  virtual ~Service() = default;

  // Returns the numeric service type.
  uint16_t ServiceType() { return type_; }

  // Adds or updates a privilege expiration timestamp.
  void AddPrivilege(uint16_t privilege, uint32_t expire) { privileges_[privilege] = expire; }

  // Serializes the complete service payload.
  virtual std::string PackService() = 0;

  // Deserializes the service payload from the unpacker.
  virtual void UnpackService(Unpacker *unpacker) = 0;

  // Creates an independent copy of the service.
  virtual std::unique_ptr<Service> Clone() const = 0;

  // Serializes the common service type and privileges.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const Service *x) {
    p << x->type_ << x->privileges_;
    return p;
  }

  // Deserializes the common privileges after the service type is consumed.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, Service *x) {
    p >> x->privileges_;
    return p;
  }

 public:
  uint16_t type_;
  std::map<uint16_t, uint32_t> privileges_;

 protected:
  // Uses the default copy constructor for derived service cloning.
  Service(const Service &) = default;
  // Uses the default move constructor for derived services.
  Service(Service &&) = default;
  // Uses the default copy assignment operator for derived services.
  Service &operator=(const Service &) = default;
  // Uses the default move assignment operator for derived services.
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
  // Creates an RTC service with a numeric user ID.
  ServiceRtc(const std::string &channel_name = "", uint32_t uid = 0) : Service(kServiceType), channel_name_(channel_name) {
    if (uid == 0) {
      account_ = "";
    } else {
      account_ = std::to_string(uid);
    }
  }

  // Creates an RTC service with a string user account.
  ServiceRtc(const std::string &channel_name, const std::string &account) : Service(kServiceType), channel_name_(channel_name), account_(account) {}

  // Serializes the RTC service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the RTC service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the RTC service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceRtc(*this)); }

  // Serializes the RTC privileges, channel name, and user account.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceRtc *x) {
    p << dynamic_cast<const Service *>(x) << x->channel_name_ << x->account_;
    return p;
  }

  // Deserializes the RTC privileges, channel name, and user account.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceRtc *x) {
    p >> dynamic_cast<Service *>(x) >> x->channel_name_ >> x->account_;
    return p;
  }

 public:
  std::string channel_name_;
  std::string account_;

 protected:
  // Uses the default copy constructor for RTC service cloning.
  ServiceRtc(const ServiceRtc &) = default;
  // Uses the default move constructor for RTC services.
  ServiceRtc(ServiceRtc &&) = default;
  // Uses the default copy assignment operator for RTC services.
  ServiceRtc &operator=(const ServiceRtc &) = default;
  // Uses the default move assignment operator for RTC services.
  ServiceRtc &operator=(ServiceRtc &&) = default;
};

class ServiceRtm : public Service {
 public:
  enum {
    kServiceType = 2,

    kPrivilegeLogin = 1,
  };

 public:
  // Creates an RTM service for the specified user ID.
  ServiceRtm(const std::string &user_id = "") : Service(kServiceType), user_id_(user_id) {}

  // Serializes the RTM service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the RTM service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the RTM service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceRtm(*this)); }

  // Serializes the RTM privileges and user ID.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceRtm *x) {
    p << dynamic_cast<const Service *>(x) << x->user_id_;
    return p;
  }

  // Deserializes the RTM privileges and user ID.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceRtm *x) {
    p >> dynamic_cast<Service *>(x) >> x->user_id_;
    return p;
  }

 public:
  std::string user_id_;

 protected:
  // Uses the default copy constructor for RTM service cloning.
  ServiceRtm(const ServiceRtm &) = default;
  // Uses the default move constructor for RTM services.
  ServiceRtm(ServiceRtm &&) = default;
  // Uses the default copy assignment operator for RTM services.
  ServiceRtm &operator=(const ServiceRtm &) = default;
  // Uses the default move assignment operator for RTM services.
  ServiceRtm &operator=(ServiceRtm &&) = default;
};

class ServiceStreaming : public Service {
 public:
  enum {
    kServiceType = 3,

    kPrivilegePublishMixStream = 1,
    kPrivilegePublishRawStream = 2,
  };

 public:
  // Creates a Streaming service with a numeric user ID.
  ServiceStreaming(const std::string &channel_name = "", uint32_t uid = 0) : Service(kServiceType), channel_name_(channel_name) {
    if (uid == 0) {
      account_ = "";
    } else {
      account_ = std::to_string(uid);
    }
  }

  // Creates a Streaming service with a string user account.
  ServiceStreaming(const std::string &channel_name, const std::string &account)
      : Service(kServiceType), channel_name_(channel_name), account_(account) {}

  // Serializes the Streaming service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the Streaming service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the Streaming service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceStreaming(*this)); }

  // Serializes the Streaming privileges, channel name, and user account.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceStreaming *x) {
    p << dynamic_cast<const Service *>(x) << x->channel_name_ << x->account_;
    return p;
  }

  // Deserializes the Streaming privileges, channel name, and user account.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceStreaming *x) {
    p >> dynamic_cast<Service *>(x) >> x->channel_name_ >> x->account_;
    return p;
  }

 public:
  std::string channel_name_;
  std::string account_;

 protected:
  // Uses the default copy constructor for Streaming service cloning.
  ServiceStreaming(const ServiceStreaming &) = default;
  // Uses the default move constructor for Streaming services.
  ServiceStreaming(ServiceStreaming &&) = default;
  // Uses the default copy assignment operator for Streaming services.
  ServiceStreaming &operator=(const ServiceStreaming &) = default;
  // Uses the default move assignment operator for Streaming services.
  ServiceStreaming &operator=(ServiceStreaming &&) = default;
};

class ServiceFpa : public Service {
 public:
  enum {
    kServiceType = 4,

    kPrivilegeLogin = 1,
  };

  // Creates an FPA service.
  ServiceFpa() : Service(kServiceType) {}

  // Serializes the FPA service payload.
  virtual std::string PackService() override { return Pack(this); }
  // Deserializes the FPA service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the FPA service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceFpa(*this)); }

  // Serializes the FPA privileges.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceFpa *x) { return p << dynamic_cast<const Service *>(x); }
  // Deserializes the FPA privileges.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceFpa *x) { return p >> dynamic_cast<Service *>(x); }

 protected:
  // Uses the default copy constructor for FPA service cloning.
  ServiceFpa(const ServiceFpa &) = default;
  // Uses the default move constructor for FPA services.
  ServiceFpa(ServiceFpa &&) = default;
  // Uses the default copy assignment operator for FPA services.
  ServiceFpa &operator=(const ServiceFpa &) = default;
  // Uses the default move assignment operator for FPA services.
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
  // Creates a Chat service for the specified user ID.
  ServiceChat(const std::string &user_id = "") : Service(kServiceType), user_id_(user_id) {}

  // Serializes the Chat service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the Chat service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the Chat service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceChat(*this)); }

  // Serializes the Chat privileges and user ID.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceChat *x) {
    p << dynamic_cast<const Service *>(x) << x->user_id_;
    return p;
  }

  // Deserializes the Chat privileges and user ID.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceChat *x) {
    p >> dynamic_cast<Service *>(x) >> x->user_id_;
    return p;
  }

 public:
  std::string user_id_;
};

class ServiceFCdn : public Service {
 public:
  enum {
    kServiceType = 6,

    kPrivilegePublish = 1,
    kPrivilegePlay = 2,
  };

 public:
  // Creates an FCDN service with a numeric user ID.
  ServiceFCdn(const std::string &channel_name = "", uint32_t uid = 0) : Service(kServiceType), channel_name_(channel_name) {
    if (uid == 0) {
      account_ = "";
    } else {
      account_ = std::to_string(uid);
    }
  }

  // Creates an FCDN service with a string user account.
  ServiceFCdn(const std::string &channel_name, const std::string &account)
      : Service(kServiceType), channel_name_(channel_name), account_(account) {}

  // Serializes the FCDN service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the FCDN service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the FCDN service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceFCdn(*this)); }

  // Serializes the FCDN privileges, channel name, and user account.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceFCdn *x) {
    p << dynamic_cast<const Service *>(x) << x->channel_name_ << x->account_;
    return p;
  }

  // Deserializes the FCDN privileges, channel name, and user account.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceFCdn *x) {
    p >> dynamic_cast<Service *>(x) >> x->channel_name_ >> x->account_;
    return p;
  }

 public:
  std::string channel_name_;
  std::string account_;

 protected:
  // Uses the default copy constructor for FCDN service cloning.
  ServiceFCdn(const ServiceFCdn &) = default;
  // Uses the default move constructor for FCDN services.
  ServiceFCdn(ServiceFCdn &&) = default;
  // Uses the default copy assignment operator for FCDN services.
  ServiceFCdn &operator=(const ServiceFCdn &) = default;
  // Uses the default move assignment operator for FCDN services.
  ServiceFCdn &operator=(ServiceFCdn &&) = default;
};

class ServiceApaas : public Service {
 public:
  enum {
    kServiceType = 7,

    kPrivilegeRoomUser = 1,
    kPrivilegeUser = 2,
    kPrivilegeApp = 3,
  };

 public:
  // Creates an APaaS service for a room, user, and role.
  ServiceApaas(const std::string &room_uuid = "", const std::string &user_uuid = "", int16_t role = -1)
      : Service(kServiceType), room_uuid_(room_uuid), user_uuid_(user_uuid), role_(role) {}

  // Serializes the APaaS service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the APaaS service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the APaaS service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceApaas(*this)); }

  // Serializes the APaaS privileges, room, user, and role.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceApaas *x) {
    p << dynamic_cast<const Service *>(x) << x->room_uuid_ << x->user_uuid_ << x->role_;
    return p;
  }

  // Deserializes the APaaS privileges, room, user, and role.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceApaas *x) {
    p >> dynamic_cast<Service *>(x) >> x->room_uuid_ >> x->user_uuid_ >> x->role_;
    return p;
  }

 public:
  std::string room_uuid_;
  std::string user_uuid_;
  int16_t role_;
};

class ServiceRtm2 : public Service {
 public:
  enum {
    kServiceType = 8,

    kPrivilegeLogin = 1,
  };

  using PermissionsDetail = std::map<uint16_t, std::map<uint16_t, std::vector<std::string>>>;
  struct Permissions {
    enum {
      kMessageChannels = 0,
      kStreamChannels = 1,
      kGourpChannels = 2,
      kServerGroups = 3,
      kUsers = 4,
    };
    enum {
      kRead = 0,
      kWrite = 1,
    };

    // Creates an empty RTM2 permission set.
    Permissions() : details_() {}

    // Adds or replaces resources for a resource and permission type.
    void Add(uint16_t resource_type, uint16_t permission_type, const std::vector<std::string> &resources) {
      details_[resource_type][permission_type] = resources;
    }

    PermissionsDetail details_;
  };

 public:
  // Creates an RTM2 service with resource-level permissions.
  ServiceRtm2(const std::string &user_id = "", const Permissions &permissions = Permissions())
      : Service(kServiceType), user_id_(user_id), permissions_(permissions) {}

  // Serializes the RTM2 service payload.
  virtual std::string PackService() override { return Pack(this); }

  // Deserializes the RTM2 service payload.
  virtual void UnpackService(Unpacker *unpacker) override { *unpacker >> this; }

  // Creates an independent copy of the RTM2 service.
  virtual std::unique_ptr<Service> Clone() const override { return std::unique_ptr<Service>(new ServiceRtm2(*this)); }

  // Serializes the RTM2 privileges, user ID, and resource permissions.
  friend agora::tools::Packer &operator<<(agora::tools::Packer &p, const ServiceRtm2 *x) {
    p << dynamic_cast<const Service *>(x) << x->user_id_ << x->permissions_.details_;
    return p;
  }

  // Deserializes the RTM2 privileges, user ID, and resource permissions.
  friend agora::tools::Unpacker &operator>>(agora::tools::Unpacker &p, ServiceRtm2 *x) {
    p >> dynamic_cast<Service *>(x) >> x->user_id_ >> x->permissions_.details_;
    return p;
  }

 public:
  std::string user_id_;
  Permissions permissions_;

 protected:
  // Uses the default copy constructor for RTM2 service cloning.
  ServiceRtm2(const ServiceRtm2 &) = default;
  // Uses the default move constructor for RTM2 services.
  ServiceRtm2(ServiceRtm2 &&) = default;
  // Uses the default copy assignment operator for RTM2 services.
  ServiceRtm2 &operator=(const ServiceRtm2 &) = default;
  // Uses the default move assignment operator for RTM2 services.
  ServiceRtm2 &operator=(ServiceRtm2 &&) = default;
};

template <class T>
struct ServiceCreator {
  // Creates a service instance for the service factory registry.
  static Service *New() { return (new T()); }
};
static const std::map<uint16_t, Service *(*)()> kServiceCreator = {
    {ServiceRtc::kServiceType, ServiceCreator<ServiceRtc>::New},
    {ServiceRtm::kServiceType, ServiceCreator<ServiceRtm>::New},
    {ServiceStreaming::kServiceType, ServiceCreator<ServiceStreaming>::New},
    {ServiceFpa::kServiceType, ServiceCreator<ServiceFpa>::New},
    {ServiceChat::kServiceType, ServiceCreator<ServiceChat>::New},
    {ServiceFCdn::kServiceType, ServiceCreator<ServiceFCdn>::New},
    {ServiceApaas::kServiceType, ServiceCreator<ServiceApaas>::New},
    {ServiceRtm2::kServiceType, ServiceCreator<ServiceRtm2>::New},
};

enum TokenStatus {
  kTokenVerifySuccess = 0,
  kTokenVerifyFailed = -1,
  kTokenInvalid = -2,
  kTokenInvalidInfo = -3,
  kTokenThrow = -4,
};

class AccessToken2 {
 public:
  // Creates a Token007 builder or an empty parser when credentials are omitted.
  AccessToken2(const std::string &app_id = "", const std::string &app_certificate = "", uint32_t issue_ts = 0, uint32_t expire = 900)
      : app_id_(app_id), app_cert_(app_certificate) {
    if (issue_ts != 0) {
      issue_ts_ = issue_ts;
    } else {
      issue_ts_ = ::time(NULL);
    }

    expire_ = expire;
    salt_ = GenerateSalt();
  }

  // Returns the Token007 version prefix.
  static std::string Version() { return "007"; }

  // Adds a service without replacing existing services of the same type.
  void AddService(std::unique_ptr<Service> service) { services_.insert(std::make_pair(service->ServiceType(), std::move(service))); }

  // Builds and signs a Token007 string from the current services.
  std::string Build() {
    if (!BuildCheck()) return "";

    auto signing = Signing();
    auto signing_info = SigningInfo();
    auto signature = Pack(HmacSign2(signing, signing_info, HMAC_SHA256_LENGTH));
    auto compressed = Compress(signature + signing_info);
    return Version() + base64Encode(compressed);
  }

  // Parses a Token007 string and clears any state from an earlier parse.
  bool FromString(const std::string &token) {
    // Clear the previous token state so a failed parse cannot reuse its signature or services.
    parsed_ = false;
    app_id_.clear();
    signature_.clear();
    raw_token_buffer_.clear();
    services_.clear();

    if (token.substr(0, VERSION_LENGTH) != Version()) {
      return false;
    }

    try {
      auto buffer = Decompress(base64Decode(token.substr(VERSION_LENGTH)));
      raw_token_buffer_ = buffer;
      Unpacker unpacker(buffer.data(), buffer.length());
      unpacker >> signature_ >> app_id_ >> issue_ts_ >> expire_ >> salt_;
      UnpackServices(&unpacker);
      parsed_ = true;
    } catch (std::exception &e) {
      return false;
    }
    return true;
  }

  // Verifies the signature retained by the most recent successful parse.
  TokenStatus VerifySignature(const std::string &app_certificate) {
    app_cert_ = app_certificate;
    if (!parsed_ || raw_token_buffer_.empty()) {
      perror("invalid token, please unpack first by FromString()");
      return kTokenInvalid;
    } else if (!IsUUID(app_id_) || !IsUUID(app_cert_)) {
      return kTokenInvalidInfo;
    }
    try {
      std::string signature;
      Unpacker unpacker(raw_token_buffer_.data(), raw_token_buffer_.length());
      unpacker >> signature;
      auto signing = Signing();

      auto signing_info = unpacker.pop_raw_string_to_end();
      auto gen_signature = HmacSign2(signing, signing_info, HMAC_SHA256_LENGTH);
      return signature == gen_signature ? kTokenVerifySuccess : kTokenVerifyFailed;
    } catch (std::exception &e) {
      perror((std::string("VerifySignature error: ") + e.what()).c_str());
      return kTokenThrow;
    }
  }

  // Generates the raw signature for the current token payload.
  std::string GenerateSignature(const std::string &app_certificate) {
    app_cert_ = app_certificate;
    if (!BuildCheck()) return "";

    auto signing = Signing();
    auto signing_info = SigningInfo();
    auto signature = HmacSign2(signing, signing_info, HMAC_SHA256_LENGTH);
    return signature;
  }

  // Derives the signing key from the issue timestamp, salt, and App Certificate.
  std::string Signing() {
    std::string signing;
    signing = HmacSign2(Pack(issue_ts_), app_cert_, HMAC_SHA256_LENGTH);
    signing = HmacSign2(Pack(salt_), signing, HMAC_SHA256_LENGTH);
    return signing;
  }

  // Serializes the token metadata and services used for signing.
  std::string SigningInfo() {
    auto signing_info = Pack(app_id_) + Pack(issue_ts_) + Pack(expire_) + Pack(salt_) + PackServices();
    return signing_info;
  }

  // Serializes all services in stable service-type order.
  std::string PackServices() {
    auto services = Pack(static_cast<uint16_t>(services_.size()));
    for (auto it = services_.begin(); it != services_.end(); ++it) {
      services += it->second->PackService();
    }
    return services;
  }

  // Parses known services and stops safely when an unknown service type is found.
  void UnpackServices(Unpacker *unpacker) {
    uint16_t service_count;
    *unpacker >> service_count;

    services_.clear();
    for (auto i = 0; i < service_count; ++i) {
      uint16_t service_type;
      *unpacker >> service_type;
      auto service_ptr = kServiceCreator.find(service_type);
      if (service_ptr == kServiceCreator.end()) {
        perror((std::string("invalid service type ") + std::to_string(service_type)).c_str());
        break;
      }
      auto service = std::unique_ptr<Service>(service_ptr->second());
      service->UnpackService(unpacker);
      services_.insert(std::make_pair(service_type, std::move(service)));
    }
  }

  // Validates the required identifiers and service list before signing.
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
  std::string raw_token_buffer_;
  bool parsed_ = false;

  std::multimap<uint16_t, std::unique_ptr<Service>> services_;
};

}  // namespace tools
}  // namespace agora
