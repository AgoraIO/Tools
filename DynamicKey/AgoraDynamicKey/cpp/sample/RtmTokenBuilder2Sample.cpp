// Copyright (c) 2014-2017 Agora.io, Inc.
//

#include <iostream>

#include "../src/RtmTokenBuilder2.h"

using namespace agora::tools;

int main(int argc, char const *argv[]) {
  (void)argc;
  (void)argv;

  std::string app_id = "970CA35de60c44645bbae8a215061b33";
  std::string app_certificate = "5CFd2fd1755d40ecb72977518be15d3b";
  std::string channel_name = "7d72365eb983485397e3e3f9d460bdda";
  std::string user_id = "test_user_id";
  uint32_t expiration_in_seconds = 3600;

  auto result = RtmTokenBuilder2::BuildToken(app_id, app_certificate, user_id,
                                             expiration_in_seconds);
  std::cout << "RTM Token:" << result << std::endl;
  return 0;
}
