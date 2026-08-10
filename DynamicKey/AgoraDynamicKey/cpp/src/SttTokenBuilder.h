// Copyright (c) 2014-2026 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/RtcTokenBuilder2.h"

namespace agora {
namespace tools {

class SttTokenBuilder {
 public:
  /**
   * Builds an STT token with RTC and RTM services.
   *
   * @param app_id The App ID issued to you by Agora.
   * @param app_certificate Certificate of the application that you registered
   * in the Agora Dashboard.
   * @param channel_name Unique channel name for the Agora RTC session in the
   * string format. The string length must be less than 64 bytes. Supported
   * character scopes are:
   * - The 26 lowercase English letters: a to z.
   * - The 26 uppercase English letters: A to Z.
   * - The 10 digits: 0 to 9.
   * - The space.
   * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=",
   * ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   * @param rtc_account The RTC user account.
   * @param rtc_role See #UserRole.
   * - UserRole::kRolePublisher = 1: RECOMMENDED. Use this role for a
   * voice/video call or a live broadcast.
   * - UserRole::kRoleSubscriber = 2: ONLY use this role if your live-broadcast
   * scenario requires authentication for co-host.
   * @param rtc_token_expire represented by the number of seconds elapsed since
   * now. If, for example, you want to access the Agora Service within 10
   * minutes after the token is generated, set rtc_token_expire as 600(seconds).
   * @param join_channel_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to join channel and expect to
   * stay in the channel for 10 minutes, set join_channel_privilege_expire as
   * 600(seconds).
   * @param pub_audio_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to enable publish audio
   * privilege for 10 minutes, set pub_audio_privilege_expire as 600(seconds).
   * @param pub_video_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to enable publish video
   * privilege for 10 minutes, set pub_video_privilege_expire as 600(seconds).
   * @param pub_data_stream_privilege_expire represented by the number of
   * seconds elapsed since now. If, for example, you want to enable publish data
   * stream privilege for 10 minutes, set pub_data_stream_privilege_expire as
   * 600(seconds).
   * @param rtm_user_id The RTM user's account, max length is 255 Bytes.
   * @param rtm_token_expire represented by the number of seconds elapsed since
   * now. If, for example, you want to access the Agora Service within 10
   * minutes after the token is generated, set rtm_token_expire as 600(seconds).
   * @return The STT token.
   */
  static std::string BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& channel_name,
                                const std::string& rtc_account, UserRole rtc_role, uint32_t rtc_token_expire,
                                uint32_t join_channel_privilege_expire, uint32_t pub_audio_privilege_expire,
                                uint32_t pub_video_privilege_expire, uint32_t pub_data_stream_privilege_expire,
                                const std::string& rtm_user_id, uint32_t rtm_token_expire);
};

inline std::string SttTokenBuilder::BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& channel_name,
                                               const std::string& rtc_account, UserRole rtc_role, uint32_t rtc_token_expire,
                                               uint32_t join_channel_privilege_expire, uint32_t pub_audio_privilege_expire,
                                               uint32_t pub_video_privilege_expire, uint32_t pub_data_stream_privilege_expire,
                                               const std::string& rtm_user_id, uint32_t rtm_token_expire) {
  AccessToken2 token(app_id, app_certificate, 0, rtc_token_expire);

  std::unique_ptr<Service> rtc_service(new ServiceRtc(channel_name, rtc_account));
  rtc_service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, join_channel_privilege_expire);
  if (rtc_role == UserRole::kRolePublisher) {
    rtc_service->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, pub_audio_privilege_expire);
    rtc_service->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, pub_video_privilege_expire);
    rtc_service->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, pub_data_stream_privilege_expire);
  }
  token.AddService(std::move(rtc_service));

  std::unique_ptr<Service> rtm_service(new ServiceRtm(rtm_user_id));
  rtm_service->AddPrivilege(ServiceRtm::kPrivilegeLogin, rtm_token_expire);
  token.AddService(std::move(rtm_service));

  std::unique_ptr<Service> stt_service(new ServiceStt());
  token.AddService(std::move(stt_service));

  return token.Build();
}

}  // namespace tools
}  // namespace agora
