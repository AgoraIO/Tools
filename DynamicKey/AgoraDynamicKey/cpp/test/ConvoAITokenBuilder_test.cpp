// Copyright (c) 2014-2026 Agora.io, Inc.

#include "../src/ConvoAITokenBuilder.h"
#include <gtest/gtest.h>

using namespace agora::tools;

TEST(ConvoAITokenBuilder, BuildToken) {
  std::string token = ConvoAITokenBuilder::BuildToken(
      "970CA35de60c44645bbae8a215061b33",
      "5CFd2fd1755d40ecb72977518be15d3b",
      "convoai-channel",
      "convoai-rtc-user",
      UserRole::kRolePublisher,
      3600,
      1800,
      1700,
      1600,
      1500,
      "convoai-rtm-user",
      1400);

  AccessToken2 parser;
  ASSERT_TRUE(parser.FromString(token));
  EXPECT_EQ(1u, parser.services_.count(ServiceConvoAI::kServiceType));
}
