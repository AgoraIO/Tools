// Copyright (c) 2014-2022 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/AccessToken2.h"
#include "cpp/src/md5/md5.h"

namespace agora {
namespace tools {

class EducationTokenBuilder2 {
 public:
  /*
   Build user room token
   @param app_id: The App ID issued to you by Agora. Apply for a new App ID
   from Agora Dashboard if it is missing from your kit. See Get an App ID.
   @param app_certificate: Certificate of the application that you registered
   in the Agora Dashboard. See Get an App Certificate.
   @param room_uuid: The room's id, must be unique.
   @param user_uuid: The user's id, must be unique.
   @param role: The user's role, such as 0(invisible), 1(teacher), 2(student),
   3(assistant), 4(observer) etc.
   @param expire: represented by the number of seconds elapsed since now. If,
   for example, you want to access the Agora Service within 10 minutes after
   the token is generated, set expireTimestamp as 600(seconds).
   @return: The education user room token.
   */
  static std::string BuildRoomUserToken(const std::string& app_id,
                                        const std::string& app_certificate,
                                        const std::string& room_uuid,
                                        const std::string& user_uuid,
                                        int16_t role, uint32_t expire);

  /*
  Build user individual token
  @param app_id: The App ID issued to you by Agora. Apply for a new App ID
  from Agora Dashboard if it is missing from your kit. See Get an App ID.
  @param app_certificate: Certificate of the application that you registered
  in the Agora Dashboard. See Get an App Certificate.
  @param user_uuid: The user's id, must be unique.
  @param expire: represented by the number of seconds elapsed since now. If,
  for example, you want to access the Agora Service within 10 minutes after
  the token is generated, set expireTimestamp as 600(seconds).
  @return: The education user token.
   */
  static std::string BuildUserToken(const std::string& app_id,
                                    const std::string& app_certificate,
                                    const std::string& user_uuid,
                                    uint32_t expire);

  /*
  Build app global token
  @param app_id: The App ID issued to you by Agora. Apply for a new App ID from
  Agora Dashboard if it is missing from your kit. See Get an App ID.
  @param app_certificate: Certificate of the application that you registered in
  the Agora Dashboard. See Get an App Certificate.
  @param expire: represented by the number of seconds elapsed since now. If,
  for example, you want to access the Agora Service within 10 minutes after the
  token is generated, set expireTimestamp as 600(seconds).
  @return: The App token.
   */
  static std::string BuildAppToken(const std::string& app_id,
                                   const std::string& app_certificate,
                                   uint32_t expire);
};

inline std::string EducationTokenBuilder2::BuildRoomUserToken(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& room_uuid, const std::string& user_uuid, int16_t role,
    uint32_t expire) {
  AccessToken2 token(app_id, app_certificate, 0, expire);

  MD5 h{user_uuid};
  std::string char_user_id = h.toStr();

  std::unique_ptr<Service> education_service(
      new ServiceEducation(room_uuid, user_uuid, role));
  education_service->AddPrivilege(ServiceEducation::kPrivilegeRoomUser, expire);
  token.AddService(std::move(education_service));

  std::unique_ptr<Service> rtm_service(new ServiceRtm(user_uuid));
  rtm_service->AddPrivilege(ServiceRtm::kPrivilegeLogin, expire);
  token.AddService(std::move(rtm_service));

  std::unique_ptr<Service> chat_service(new ServiceChat(char_user_id));
  chat_service->AddPrivilege(ServiceChat::kPrivilegeUser, expire);
  token.AddService(std::move(chat_service));

  return token.Build();
}

inline std::string EducationTokenBuilder2::BuildUserToken(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& user_uuid, uint32_t expire) {
  AccessToken2 token(app_id, app_certificate, 0, expire);

  std::unique_ptr<Service> education_service(
      new ServiceEducation("", user_uuid));
  education_service->AddPrivilege(ServiceEducation::kPrivilegeUser, expire);
  token.AddService(std::move(education_service));

  return token.Build();
}

inline std::string EducationTokenBuilder2::BuildAppToken(
    const std::string& app_id, const std::string& app_certificate,
    uint32_t expire) {
  AccessToken2 token(app_id, app_certificate, 0, expire);

  std::unique_ptr<Service> education_service(new ServiceEducation());
  education_service->AddPrivilege(ServiceEducation::kPrivilegeApp, expire);
  token.AddService(std::move(education_service));

  return token.Build();
}

}  // namespace tools
}  // namespace agora
