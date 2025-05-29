// Copyright (c) 2014-2024 Agora.io, Inc.

#include <cstdlib>
#include <iostream>

#include "../src/RtcTokenBuilder2.h"

using namespace agora::tools;

int main(int argc, char const *argv[]) {
  (void)argc;
  (void)argv;

  // Need to set environment variable AGORA_APP_ID
  const char *env_app_id = getenv("AGORA_APP_ID");
  std::string app_id = env_app_id ? env_app_id : "";
  // Need to set environment variable AGORA_APP_CERTIFICATE
  const char *env_app_certificate = getenv("AGORA_APP_CERTIFICATE");
  std::string app_certificate = env_app_certificate ? env_app_certificate : "";

  std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";
  uint32_t uid = 2882341273;
  std::string account = "2882341273";
  uint32_t token_expiration_in_seconds = 3600;
  uint32_t privilege_expiration_in_seconds = 3600;
  uint32_t join_channel_privilege_expiration_in_seconds = 3600;
  uint32_t pub_audio_privilege_expiration_in_seconds = 3600;
  uint32_t pub_video_privilege_expiration_in_seconds = 3600;
  uint32_t pub_data_stream_privilege_expiration_in_seconds = 3600;
  std::string result;

  std::cout << "App Id:" << app_id << std::endl;
  std::cout << "App Certificate:" << app_certificate << std::endl;
  if (app_id == "" || app_certificate == "") {
    std::cout << "Need to set environment variable AGORA_APP_ID and "
                 "AGORA_APP_CERTIFICATE"
              << std::endl;
    return -1;
  }

  result = RtcTokenBuilder2::BuildTokenWithUid(app_id, app_certificate, channel_name, uid, UserRole::kRolePublisher, token_expiration_in_seconds,
                                               privilege_expiration_in_seconds);
  std::cout << "Token With Int Uid:" << result << std::endl;

  result = RtcTokenBuilder2::BuildTokenWithUserAccount(app_id, app_certificate, channel_name, account, UserRole::kRolePublisher, token_expiration_in_seconds,
                                                       privilege_expiration_in_seconds);
  std::cout << "Token With UserAccount:" << result << std::endl;

  result = RtcTokenBuilder2::BuildTokenWithUid(app_id, app_certificate, channel_name, uid, token_expiration_in_seconds,
                                               join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
                                               pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
  std::cout << "Token With Int Uid:" << result << std::endl;

  result = RtcTokenBuilder2::BuildTokenWithUserAccount(app_id, app_certificate, channel_name, account, token_expiration_in_seconds,
                                                       join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
                                                       pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds);
  std::cout << "Token With UserAccount:" << result << std::endl;

  result = RtcTokenBuilder2::BuildTokenWithRtm(app_id, app_certificate, channel_name, account, UserRole::kRolePublisher, token_expiration_in_seconds,
                                               privilege_expiration_in_seconds);
  std::cout << "Token With RTM:" << result << std::endl;

  result = RtcTokenBuilder2::BuildTokenWithRtm2(app_id, app_certificate, channel_name, account, UserRole::kRolePublisher, token_expiration_in_seconds,
                                                join_channel_privilege_expiration_in_seconds, pub_audio_privilege_expiration_in_seconds,
                                                pub_video_privilege_expiration_in_seconds, pub_data_stream_privilege_expiration_in_seconds, account,
                                                token_expiration_in_seconds);
  std::cout << "Token With RTM:" << result << std::endl;

  return 0;
}
