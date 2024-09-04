// Copyright (c) 2014-2024 Agora.io, Inc.

#include <cstdlib>
#include <iostream>

#include "../src/EducationTokenBuilder2.h"

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

  std::string room_uuid = "123";
  std::string user_uuid = "2882341273";
  int16_t role = 1;
  uint32_t expiration_in_seconds = 600;

  std::cout << "App Id:" << app_id << std::endl;
  std::cout << "App Certificate:" << app_certificate << std::endl;
  if (app_id == "" || app_certificate == "") {
    std::cout << "Need to set environment variable AGORA_APP_ID and "
                 "AGORA_APP_CERTIFICATE"
              << std::endl;
    return -1;
  }

  auto room_user_token = EducationTokenBuilder2::BuildRoomUserToken(app_id, app_certificate, room_uuid, user_uuid, role, expiration_in_seconds);
  std::cout << "Education room user token:" << room_user_token << std::endl;

  auto user_token = EducationTokenBuilder2::BuildUserToken(app_id, app_certificate, user_uuid, expiration_in_seconds);
  std::cout << "Education user token:" << user_token << std::endl;

  auto app_token = EducationTokenBuilder2::BuildAppToken(app_id, app_certificate, expiration_in_seconds);
  std::cout << "Education app token:" << app_token << std::endl;

  return 0;
}
