using AgoraIO.Media;
using Xunit;

namespace AgoraIO.Tests
{
    public class ConvoAITokenBuilderTest
    {
        [Fact]
        public void buildToken_Publisher()
        {
            string token = ConvoAITokenBuilder.buildToken(
                "970CA35de60c44645bbae8a215061b33",
                "5CFd2fd1755d40ecb72977518be15d3b",
                "convoai-channel",
                "convoai-rtc-user",
                RtcTokenBuilder2.Role.RolePublisher,
                3600,
                1800,
                1700,
                1600,
                1500,
                "convoai-rtm-user",
                1400
            );
            AccessToken2 parsed = new AccessToken2();

            Assert.True(parsed.parse(token));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_CONVOAI));
        }
    }
}
