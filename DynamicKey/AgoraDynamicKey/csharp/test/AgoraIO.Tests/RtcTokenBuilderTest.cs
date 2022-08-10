using AgoraIO.Media;
using System;
using Xunit;
using Xunit.Abstractions;

namespace AgoraIO.Tests
{
    public class RtcTokenBuilderTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _channelName = "7d72365eb983485397e3e3f9d460bdda";
        private string _account = "2882341273";
        private uint _uid = 2882341273;
        private uint _expireTimeInSeconds = 3600;
        protected readonly ITestOutputHelper Output;

        public RtcTokenBuilderTest(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        [Fact]
        public void testBuildTokenWithUserAccount()
        {
            uint privilegeExpiredTs = _expireTimeInSeconds + (uint)Utils.getTimestamp();
            string token = RtcTokenBuilder.buildTokenWithUserAccount(_appId, _appCertificate, _channelName, _account, RtcTokenBuilder.Role.RolePublisher, privilegeExpiredTs);

            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }

        [Fact]
        public void testBuildTokenWithUID()
        {
            uint privilegeExpiredTs = _expireTimeInSeconds + (uint)Utils.getTimestamp();
            string token = RtcTokenBuilder.buildTokenWithUID(_appId, _appCertificate, _channelName, _uid, RtcTokenBuilder.Role.RolePublisher, privilegeExpiredTs);

            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }
    }
}