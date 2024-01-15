// Copyright (c) 2014-2017 Agora.io, Inc.
//

#include <iostream>

#include "../src/FpaTokenBuilder.h"

using namespace agora::tools;

int main(int argc, char const *argv[])
{
  (void)argc;
  (void)argv;

  // Need to set environment variable AGORA_APP_ID
  std::string app_id = getenv("AGORA_APP_ID");
  // Need to set environment variable AGORA_APP_CERTIFICATE
  std::string app_certificate = getenv("AGORA_APP_CERTIFICATE");

  std::string result;
  result = FpaTokenBuilder::BuildToken(app_id, app_certificate);
  std::cout << "Token with FPA service:" << result << std::endl;
}
