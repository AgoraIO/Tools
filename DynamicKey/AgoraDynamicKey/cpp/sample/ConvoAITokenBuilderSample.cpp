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

  std::cout << "App Id:" << app_id << std::endl;
  if (app_id.empty() || app_certificate.empty()) {
    std::cout << "Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE" << std::endl;
    return -1;
  }

  std::string token = ConvoAITokenBuilder::BuildToken(
      app_id, app_certificate, "7d72365eb983485397e3e3f9d460bdda", "2882341273", UserRole::kRolePublisher,
      3600, 3600, 3600, 3600, 3600, "2882341273", 3600);
  std::cout << "ConvoAI token:" << token << std::endl;
  return 0;
}
