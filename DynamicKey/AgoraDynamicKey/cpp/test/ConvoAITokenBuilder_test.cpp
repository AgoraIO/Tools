// Copyright (c) 2014-2026 Agora.io, Inc.

#include "../src/ConvoAITokenBuilder.h"
#include <gtest/gtest.h>

using namespace agora::tools;

TEST(ConvoAITokenBuilder, BuildToken) {
  std::string token = ConvoAITokenBuilder::BuildToken(
      "970CA35de60c44645bbae8a215061b33",
      "5CFd2fd1755d40ecb72977518be15d3b",
      "7d72365eb983485397e3e3f9d460bdda",
      "2882341273",
      UserRole::kRolePublisher,
      600,
      600,
      600,
      600,
      600,
      "2882341273",
      600);

  AccessToken2 parser;
  ASSERT_TRUE(parser.FromString(token));
  EXPECT_EQ(1u, parser.services_.count(ServiceConvoAI::kServiceType));
}
