// Copyright (c) 2014-2017 Agora.io, Inc.
//

#include <iostream>

#include "../src/FpaTokenBuilder.h"

using namespace agora::tools;

int main(int argc, char const *argv[]) {
  (void)argc;
  (void)argv;

  std::string app_id = "970CA35de60c44645bbae8a215061b33";
  std::string app_certificate = "5CFd2fd1755d40ecb72977518be15d3b";

  std::string result;
  result = FpaTokenBuilder::BuildToken(app_id, app_certificate);
  std::cout << "Token with FPA service:" << result << std::endl;

}

