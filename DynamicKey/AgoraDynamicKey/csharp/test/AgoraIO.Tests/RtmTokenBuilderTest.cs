using AgoraIO.Rtm;
using AgoraIO.Media;
using System;
using Xunit;
using Xunit.Abstractions;

namespace AgoraIO.Tests
{
    public class RtmTokenBuilderTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _account = "2882341273";
        private uint _expireTimeInSeconds = 3600;
        protected readonly ITestOutputHelper Output;

        public RtmTokenBuilderTest(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        [Fact]
        public void testBuildToken()
        {
            uint privilegeExpiredTs = _expireTimeInSeconds + (uint)Utils.getTimestamp();
            string token = RtmTokenBuilder.buildToken(_appId, _appCertificate, _account, privilegeExpiredTs);

            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }
    }
}