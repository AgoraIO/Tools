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
                "7d72365eb983485397e3e3f9d460bdda",
                "2882341273",
                RtcTokenBuilder2.Role.RolePublisher,
                600,
                600,
                600,
                600,
                600,
                "2882341273",
                600
            );
            AccessToken2 parsed = new AccessToken2();

            Assert.True(parsed.parse(token));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_CONVOAI));
        }
    }
}
