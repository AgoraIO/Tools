// Copyright (c) 2014-2026 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/RtcTokenBuilder2.h"

namespace agora {
namespace tools {

class ConvoAITokenBuilder {
 public:
  /**
   * Builds a ConvoAI token with RTC and RTM services.
   *
   * @param app_id The App ID issued to you by Agora.
   * @param app_certificate Certificate of the application registered in the Agora Dashboard.
   * @param channel_name The unique channel name for the Agora RTC session in string format. The string length
   * must be less than 64 bytes. The channel name may contain the following characters:
   * - All lowercase English letters: a to z.
   * - All uppercase English letters: A to Z.
   * - All numeric characters: 0 to 9.
   * - The space character.
   * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   * @param account The account used by both RTC and RTM, max length is 255 bytes.
   * @param token_expire The whole token lifetime in seconds from now. Defaults to 86400 seconds.
   * @param privilege_expire The RTC and RTM privilege lifetime in seconds from now. Defaults to 0 and must
   * not exceed token_expire; otherwise, it is limited by the token expiration time.
   * @return The ConvoAI token.
   */
  static std::string BuildToken(const std::string& app_id, const std::string& app_certificate, const std::string& channel_name,
                                const std::string& account, uint32_t token_expire = 86400,
                                uint32_t privilege_expire = 0);

  /**
   * Builds a ConvoAI token with RTC and RTM services.
   *
   * @param app_id The App ID issued to you by Agora.
   * @param app_certificate Certificate of the application that you registered
   * in the Agora Dashboard.
   * @param channel_name The unique channel name for the Agora RTC session in string format. The string length
   * must be less than 64 bytes. The channel name may contain the following characters:
   * - All lowercase English letters: a to z.
   * - All uppercase English letters: A to Z.
   * - All numeric characters: 0 to 9.
   * - The space character.
   * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=",
   * ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   * @param rtc_account The RTC user account.
   * @param rtc_role See #UserRole.
   * - UserRole::kRolePublisher = 1: RECOMMENDED. Use this role for a
   * voice/video call or a live broadcast.
   * - UserRole::kRoleSubscriber = 2: ONLY use this role if your live-broadcast
   * scenario requires authentication for co-host.
   * @param rtc_token_expire The token expiration time, represented by the
   * number of seconds elapsed since now. The whole token is invalid after this
   * time, even if a privilege expiration time is later. If, for example, you
   * want to access the Agora Service within 10 minutes after the token is
   * generated, set rtc_token_expire as 600(seconds).
   * @param join_channel_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to join channel and expect to
   * stay in the channel for 10 minutes, set join_channel_privilege_expire as
   * 600(seconds). This value must not exceed rtc_token_expire; otherwise, the
   * privilege is limited by the token expiration time.
   * @param pub_audio_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to enable publish audio
   * privilege for 10 minutes, set pub_audio_privilege_expire as 600(seconds).
   * This value must not exceed rtc_token_expire; otherwise, the privilege is
   * limited by the token expiration time.
   * @param pub_video_privilege_expire represented by the number of seconds
   * elapsed since now. If, for example, you want to enable publish video
   * privilege for 10 minutes, set pub_video_privilege_expire as 600(seconds).
   * This value must not exceed rtc_token_expire; otherwise, the privilege is
   * limited by the token expiration time.
   * @param pub_data_stream_privilege_expire represented by the number of
   * seconds elapsed since now. If, for example, you want to enable publish data
   * stream privilege for 10 minutes, set pub_data_stream_privilege_expire as
   * 600(seconds). This value must not exceed rtc_token_expire; otherwise, the
   * privilege is limited by the token expiration time.
   * @param rtm_user_id The RTM user's account, max length is 255 Bytes.
   * @param rtm_token_expire represented by the number of seconds elapsed since
   * now. If, for example, you want to access the Agora Service within 10
   * minutes after the token is generated, set rtm_token_expire as 600(seconds).
   * This value must not exceed rtc_token_expire; otherwise, the RTM login
   * privilege is limited by the token expiration time.
   * @return The ConvoAI token.
   */
  static std::string BuildTokenWithPrivilege(const std::string& app_id, const std::string& app_certificate,
                                             const std::string& channel_name, const std::string& rtc_account,
                                             UserRole rtc_role, uint32_t rtc_token_expire,
                                             uint32_t join_channel_privilege_expire, uint32_t pub_audio_privilege_expire,
                                             uint32_t pub_video_privilege_expire, uint32_t pub_data_stream_privilege_expire,
                                             const std::string& rtm_user_id, uint32_t rtm_token_expire);
};

inline std::string ConvoAITokenBuilder::BuildToken(const std::string& app_id, const std::string& app_certificate,
                                                   const std::string& channel_name, const std::string& account,
                                                   uint32_t token_expire, uint32_t privilege_expire) {
  return BuildTokenWithPrivilege(app_id, app_certificate, channel_name, account, UserRole::kRolePublisher,
                                 token_expire, privilege_expire, privilege_expire, privilege_expire,
                                 privilege_expire, account, privilege_expire);
}

inline std::string ConvoAITokenBuilder::BuildTokenWithPrivilege(
    const std::string& app_id, const std::string& app_certificate, const std::string& channel_name,
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

  std::unique_ptr<Service> convoai_service(new ServiceConvoAI());
  token.AddService(std::move(convoai_service));

  return token.Build();
}

}  // namespace tools
}  // namespace agora
