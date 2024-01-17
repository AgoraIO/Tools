// Copyright (c) 2014-2024 Agora.io, Inc.

#include <iostream>
#include <cstdlib>

#include "../src/FpaTokenBuilder.h"

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

  std::cout << "App Id:" << app_id << std::endl;
  std::cout << "App Certificate:" << app_certificate << std::endl;
  if (app_id == "" || app_certificate == "")
  {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  auto token = FpaTokenBuilder::BuildToken(app_id, app_certificate);
  std::cout << "Token with FPA service:" << token << std::endl;
}
