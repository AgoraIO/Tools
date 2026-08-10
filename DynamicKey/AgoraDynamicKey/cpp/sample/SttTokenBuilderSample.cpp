// Copyright (c) 2014-2026 Agora.io, Inc.

#include <cstdlib>
#include <iostream>

#include "../src/SttTokenBuilder.h"

using namespace agora::tools;

int main() {
  const char *env_app_id = getenv("AGORA_APP_ID");
  std::string app_id = env_app_id ? env_app_id : "";
  const char *env_app_certificate = getenv("AGORA_APP_CERTIFICATE");
  std::string app_certificate = env_app_certificate ? env_app_certificate : "";

  std::cout << "App Id:" << app_id << std::endl;
  if (app_id.empty() || app_certificate.empty()) {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  std::string token = SttTokenBuilder::BuildToken(
      app_id, app_certificate, "stt-channel", "stt-rtc-user", UserRole::kRolePublisher,
      3600, 3600, 3600, 3600, 3600, "stt-rtm-user", 3600);
  std::cout << "STT token:" << token << std::endl;
  return 0;
}
