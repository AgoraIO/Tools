// Copyright (c) 2014-2026 Agora.io, Inc.

#include <cstdlib>
#include <iostream>

#include "../src/ConvoAITokenBuilder.h"

using namespace agora::tools;

int main() {
  const char *env_app_id = getenv("AGORA_APP_ID");
  std::string app_id = env_app_id ? env_app_id : "";
  const char *env_app_certificate = getenv("AGORA_APP_CERTIFICATE");
  std::string app_certificate = env_app_certificate ? env_app_certificate : "";
  std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";
  std::string account = "2882341273";
  uint32_t token_expire = 3600;
  uint32_t privilege_expire = 3600;
  std::string rtc_account = "2882341273";
  UserRole rtc_role = UserRole::kRolePublisher;
  uint32_t rtc_token_expire = 3600;
  uint32_t join_channel_privilege_expire = 3600;
  uint32_t pub_audio_privilege_expire = 3600;
  uint32_t pub_video_privilege_expire = 3600;
  uint32_t pub_data_stream_privilege_expire = 3600;
  std::string rtm_user_id = "2882341273";
  uint32_t rtm_token_expire = 3600;

  std::cout << "App Id:" << app_id << std::endl;
  if (app_id.empty() || app_certificate.empty()) {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  std::string token = ConvoAITokenBuilder::BuildToken(
      app_id, app_certificate, channel_name, account, token_expire, privilege_expire);
  std::cout << "ConvoAI token:" << token << std::endl;

  std::string token_with_privilege = ConvoAITokenBuilder::BuildTokenWithPrivilege(
      app_id, app_certificate, channel_name, rtc_account, rtc_role, rtc_token_expire,
      join_channel_privilege_expire, pub_audio_privilege_expire, pub_video_privilege_expire,
      pub_data_stream_privilege_expire, rtm_user_id, rtm_token_expire);
  std::cout << "ConvoAI token with privilege:" << token_with_privilege << std::endl;
  return 0;
}
