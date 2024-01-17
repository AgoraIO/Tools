// Copyright (c) 2014-2024 Agora.io, Inc.

#include <iostream>
#include <cstdlib>

#include "../src/ChatTokenBuilder2.h"

using namespace agora::tools;

int main(int argc, char const *argv[])
{
  (void)argc;
  (void)argv;

  // Need to set environment variable AGORA_APP_ID
  const char *env_app_id = getenv("AGORA_APP_ID");
  std::string app_id = env_app_id ? env_app_id : "";
  // Need to set environment variable AGORA_APP_CERTIFICATE
  const char *env_app_certificate = getenv("AGORA_APP_CERTIFICATE");
  std::string app_certificate = env_app_certificate ? env_app_certificate : "";

  std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";
  std::string user_id = "test_user_id";
  uint32_t expiration_in_seconds = 600;

  std::cout << "App Id:" << app_id << std::endl;
  std::cout << "App Certificate:" << app_certificate << std::endl;
  if (app_id == "" || app_certificate == "")
  {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  auto user_token = ChatTokenBuilder2::BuildUserToken(app_id, app_certificate, user_id,
                                                      expiration_in_seconds);
  std::cout << "Chat User Token:" << user_token << std::endl;

  auto app_token = ChatTokenBuilder2::BuildAppToken(app_id, app_certificate,
                                                    expiration_in_seconds);
  std::cout << "Chat App Token:" << app_token << std::endl;

  return 0;
}
