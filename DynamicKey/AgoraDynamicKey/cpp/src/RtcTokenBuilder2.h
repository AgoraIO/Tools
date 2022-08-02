// Copyright (c) 2014-2017 Agora.io, Inc.
//

#pragma once  // NOLINT(build/header_guard)

#include <memory>
#include <string>

#include "cpp/src/AccessToken2.h"

namespace agora {
namespace tools {

enum class UserRole {
  /**
   RECOMMENDED. Use this role for a voice/video call or a live broadcast, if
   your scenario does not require authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   */
  kRolePublisher = 1,
  /**
   Only use this role if your scenario require authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).

   @note In order for this role to take effect, please contact our support team
   to enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   */
  kRoleSubscriber = 2,
};

class RtcTokenBuilder2 {
 public:
  /**
   Builds an RTC token using an int uid.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param channel_name The unique channel name for the AgoraRTC session in the
   string format. The string length must be less than 64 bytes. Supported
   character scopes are:
   - The 26 lowercase English letters: a to z.
   - The 26 uppercase English letters: A to Z.
   - The 10 digits: 0 to 9.
   - The space.
   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">",
   "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   @param uid User ID. A 32-bit unsigned integer with a value ranging from 1 to
   (2^32-1).
   @param role See #userRole.
   - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a
   live broadcast.
   - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario
   requires authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   In order for this role to take effect, please contact our support team to
   enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   @param token_expire represented by the number of seconds elapsed since now. If,
   for example, you want to access the Agora Service within 10 minutes after the
   token is generated, set token_expire as 600(seconds).
   @param privilege_expire represented by the number of seconds elapsed since now. If, for
   example, you want to enable your privilege for 10 minutes, set privilege_expire
   as 600(seconds).
   @return The new Token.
   */

  static std::string BuildTokenWithUid(const std::string& app_id,
                                       const std::string& app_certificate,
                                       const std::string& channel_name,
                                       uint32_t uid, UserRole role,
                                       uint32_t token_expire,
                                       uint32_t privilege_expire = 0);

  /**
   Builds an RTC token using a string userAccount.

   @param app_id The App ID issued to you by Agora.
   @param app_certificate Certificate of the application that you registered in
   the Agora Dashboard.
   @param channel_name Unique channel name for the AgoraRTC session in the
   string format. The string length must be less than 64 bytes. Supported
   character scopes are:
   - The 26 lowercase English letters: a to z.
   - The 26 uppercase English letters: A to Z.
   - The 10 digits: 0 to 9.
   - The space.
   - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">",
   "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
   @param user_account The user account.
   @param role See #userRole.
   - Role_Publisher = 1: RECOMMENDED. Use this role for a voice/video call or a
   live broadcast.
   - Role_Subscriber = 2: ONLY use this role if your live-broadcast scenario
   requires authentication for
   [Hosting-in](https://docs.agora.io/en/Agora%20Platform/terms?platform=All%20Platforms#hosting-in).
   In order for this role to take effect, please contact our support team to
   enable authentication for Hosting-in for you. Otherwise, Role_Subscriber
   still has the same privileges as Role_Publisher.
   @param token_expire represented by the number of seconds elapsed since now. If,
   for example, you want to access the Agora Service within 10 minutes after the
   token is generated, set token_expire as 600(seconds).
   @param privilege_expire represented by the number of seconds elapsed since now. If, for
   example, you want to enable your privilege for 10 minutes, set privilege_expire
   as 600(seconds).
   @return The new Token.
   */
  static std::string BuildTokenWithUserAccount(
      const std::string& app_id, const std::string& app_certificate,
      const std::string& channel_name, const std::string& user_account,
      UserRole role, uint32_t token_expire, uint32_t privilege_expire = 0);

  /**
  * Generates a RTC token with specified privileges.
  *
  * This method supports generating a token with the following privileges:
  * - Joining an RTC channel.
  * - Publishing audio in an RTC channel.
  * - Publishing video in an RTC channel.
  * - Publishing data streams in an RTC channel.
  *
  * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
  * enabled co-host authentication.
  *
  * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
  * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
  * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
  * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
  * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
  * the channel.
  *
  * @note
  * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
  * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
  * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
  * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
  *
  * @param app_id The App ID of your Agora project.
  * @param app_certificate The App Certificate of your Agora project.
  * @param channel_name The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
  * - All lowercase English letters: a to z.
  * - All uppercase English letters: A to Z.
  * - All numeric characters: 0 to 9.
  * - The space character.
  * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
  * @param uid The user ID. A 32-bit unsigned integer with a value range from 1 to (2^32 - 1). It must be unique. Set uid as 0, if you do not want to authenticate the user ID, that is, any uid from the app client can join the channel.
  * @param token_expire represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set token_expire as 600(seconds).
  * @param join_channel_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to join channel and expect stay in the channel for 10 minutes, set join_channel_privilege_expire as 600(seconds).
  * @param pub_audio_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish audio privilege for 10 minutes, set pub_audio_privilege_expire as 600(seconds).
  * @param pub_video_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish video privilege for 10 minutes, set pub_video_privilege_expire as 600(seconds).
  * @param pub_data_stream_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish data stream privilege for 10 minutes, set pub_data_stream_privilege_expire as 600(seconds).
  * @return The new Token
  */
  static std::string BuildTokenWithUid(
       const std::string& app_id,
       const std::string& app_certificate,
       const std::string& channel_name,
       uint32_t uid,
       uint32_t token_expire,
       uint32_t join_channel_privilege_expire = 0,
       uint32_t pub_audio_privilege_expire = 0,
       uint32_t pub_video_privilege_expire = 0,
       uint32_t pub_data_stream_privilege_expire = 0);

  /**
  * Generates a RTC token with specified privileges.
  *
  * This method supports generating a token with the following privileges:
  * - Joining an RTC channel.
  * - Publishing audio in an RTC channel.
  * - Publishing video in an RTC channel.
  * - Publishing data streams in an RTC channel.
  *
  * The privileges for publishing audio, video, and data streams in an RTC channel apply only if you have
  * enabled co-host authentication.
  *
  * A user can have multiple privileges. Each privilege is valid for a maximum of 24 hours.
  * The SDK triggers the onTokenPrivilegeWillExpire and onRequestToken callbacks when the token is about to expire
  * or has expired. The callbacks do not report the specific privilege affected, and you need to maintain
  * the respective timestamp for each privilege in your app logic. After receiving the callback, you need
  * to generate a new token, and then call renewToken to pass the new token to the SDK, or call joinChannel to re-join
  * the channel.
  *
  * @note
  * Agora recommends setting a reasonable timestamp for each privilege according to your scenario.
  * Suppose the expiration timestamp for joining the channel is set earlier than that for publishing audio.
  * When the token for joining the channel expires, the user is immediately kicked off the RTC channel
  * and cannot publish any audio stream, even though the timestamp for publishing audio has not expired.
  *
  * @param app_id The App ID of your Agora project.
  * @param app_certificate The App Certificate of your Agora project.
  * @param channel_name The unique channel name for the Agora RTC session in string format. The string length must be less than 64 bytes. The channel name may contain the following characters:
  * - All lowercase English letters: a to z.
  * - All uppercase English letters: A to Z.
  * - All numeric characters: 0 to 9.
  * - The space character.
  * - "!", "#", "$", "%", "&", "(", ")", "+", "-", ":", ";", "<", "=", ".", ">", "?", "@", "[", "]", "^", "_", " {", "}", "|", "~", ",".
  * @param user_account The user account.
  * @param token_expire represented by the number of seconds elapsed since now. If, for example, you want to access the Agora Service within 10 minutes after the token is generated, set token_expire as 600(seconds).
  * @param join_channel_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to join channel and expect stay in the channel for 10 minutes, set join_channel_privilege_expire as 600(seconds).
  * @param pub_audio_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish audio privilege for 10 minutes, set pub_audio_privilege_expire as 600(seconds).
  * @param pub_video_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish video privilege for 10 minutes, set pub_video_privilege_expire as 600(seconds).
  * @param pub_data_stream_privilege_expire represented by the number of seconds elapsed since now. If, for example, you want to enable publish data stream privilege for 10 minutes, set pub_data_stream_privilege_expire as 600(seconds).
  * @return The new Token
  */
  static std::string BuildTokenWithUserAccount(
       const std::string& app_id,
       const std::string& app_certificate,
       const std::string& channel_name,
       const std::string& user_account,
       uint32_t token_expire,
       uint32_t join_channel_privilege_expire = 0,
       uint32_t pub_audio_privilege_expire = 0,
       uint32_t pub_video_privilege_expire = 0,
       uint32_t pub_data_stream_privilege_expire = 0);
};


inline std::string RtcTokenBuilder2::BuildTokenWithUid(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& channel_name, uint32_t uid, UserRole role,
    uint32_t token_expire, uint32_t privilege_expire) {
  std::string account;
  if (uid != 0) {
    account = std::to_string(uid);
  }
  return RtcTokenBuilder2::BuildTokenWithUserAccount(
      app_id, app_certificate, channel_name, account, role, token_expire, privilege_expire);
}

inline std::string RtcTokenBuilder2::BuildTokenWithUserAccount(
    const std::string& app_id, const std::string& app_certificate,
    const std::string& channel_name, const std::string& user_account,
    UserRole role, uint32_t token_expire, uint32_t privilege_expire) {
  std::unique_ptr<Service> service(
      new ServiceRtc(channel_name, user_account));
  service->AddPrivilege(ServiceRtc::kPrivilegeJoinChannel, privilege_expire);
  if (role == UserRole::kRolePublisher) {
    service->AddPrivilege(ServiceRtc::kPrivilegePublishAudioStream, privilege_expire);
    service->AddPrivilege(ServiceRtc::kPrivilegePublishVideoStream, privilege_expire);
    service->AddPrivilege(ServiceRtc::kPrivilegePublishDataStream, privilege_expire);
  }

  AccessToken2 generator(app_id, app_certificate, 0, token_expire);
  generator.AddService(std::move(service));

  return generator.Build();
}

inline std::string RtcTokenBuilder2::BuildTokenWithUid(
    const std::string& app_id,
    const std::string& app_certificate,
    const std::string& channel_name,
    uint32_t uid,
    uint32_t token_expire,
    uint32_t join_channel_privilege_expire,
    uint32_t pub_audio_privilege_expire,
    uint32_t pub_video_privilege_expire,
    uint32_t pub_data_stream_privilege_expire) {
  std::string account;
  if (uid != 0) {
    account = std::to_string(uid);
  }
  return RtcTokenBuilder2::BuildTokenWithUserAccount(app_id,
                                   app_certificate,
                                   channel_name,
                                   account,
                                   token_expire,
                                   join_channel_privilege_expire,
                                   pub_audio_privilege_expire,
                                   pub_video_privilege_expire,
                                   pub_data_stream_privilege_expire);
}

inline std::string RtcTokenBuilder2::BuildTokenWithUserAccount(
    const std::string& app_id,
    const std::string& app_certificate,
    const std::string& channel_name,
    const std::string& user_account,
    uint32_t token_expire,
    uint32_t join_channel_privilege_expire,
    uint32_t pub_audio_privilege_expire,
    uint32_t pub_video_privilege_expire,
    uint32_t pub_data_stream_privilege_expire) {
  std::unique_ptr<Service> service(
      new ServiceRtc(channel_name, user_account));
  service->AddPrivilege(
      ServiceRtc::kPrivilegeJoinChannel, join_channel_privilege_expire);
  service->AddPrivilege(
      ServiceRtc::kPrivilegePublishAudioStream, pub_audio_privilege_expire);
  service->AddPrivilege(
      ServiceRtc::kPrivilegePublishVideoStream, pub_video_privilege_expire);
  service->AddPrivilege(
      ServiceRtc::kPrivilegePublishDataStream, pub_data_stream_privilege_expire);

  AccessToken2 generator(app_id, app_certificate, 0, token_expire);
  generator.AddService(std::move(service));

  return generator.Build();
}
}  // namespace tools
}  // namespace agora
