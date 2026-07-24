using AgoraIO.Media;
using System;
using Xunit;
using Xunit.Abstractions;

namespace AgoraIO.Tests
{
    public class RtcTokenBuilder2Test
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _channelName = "7d72365eb983485397e3e3f9d460bdda";
        private string _account = "2882341273";
        private uint _uid = 2882341273;
        private uint _tokenExpirationInSeconds = 3600;
        private uint _privilegeExpirationInSeconds = 3600;
        private uint _joinChannelPrivilegeExpireInSeconds = 3600;
        private uint _pubAudioPrivilegeExpireInSeconds = 3600;
        private uint _pubVideoPrivilegeExpireInSeconds = 3600;
        private uint _pubDataStreamPrivilegeExpireInSeconds = 3600;

        protected readonly ITestOutputHelper Output;

        // Creates the test fixture with an xUnit output sink.
        public RtcTokenBuilder2Test(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        // Verifies publisher RTC token generation with a numeric user ID.
        [Fact]
        public void testBuildTokenWithUID()
        {
            string token = RtcTokenBuilder2.buildTokenWithUid(_appId, _appCertificate, _channelName, _uid, RtcTokenBuilder2.Role.RolePublisher, _tokenExpirationInSeconds, _privilegeExpirationInSeconds);

            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }

        // Verifies publisher RTC token generation with a user account.
        [Fact]
        public void testBuildTokenWithUserAccount()
        {
            string token = RtcTokenBuilder2.buildTokenWithUserAccount(_appId, _appCertificate, _channelName, _account, RtcTokenBuilder2.Role.RolePublisher, _tokenExpirationInSeconds, _privilegeExpirationInSeconds);

            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }

        // Verifies combined RTC and RTM token generation.
        [Fact]
        public void testbuildTokenWithRtm()
        {
            string token = RtcTokenBuilder2.buildTokenWithRtm(_appId, _appCertificate, _channelName, _account, RtcTokenBuilder2.Role.RolePublisher, _tokenExpirationInSeconds, _privilegeExpirationInSeconds);
            AccessToken2 parsed = new AccessToken2();

            Output.WriteLine(">> token");
            Output.WriteLine(token);
            Assert.True(parsed.parse(token));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_RTC));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_RTM));
            Assert.True(parsed.verifySignature(_appCertificate));
        }

        // Verifies combined RTC and RTM token generation with independent privileges.
        [Fact]
        public void testbuildTokenWithRtm2()
        {
            string token = RtcTokenBuilder2.buildTokenWithRtm2(_appId, _appCertificate, _channelName, _account, RtcTokenBuilder2.Role.RolePublisher, _tokenExpirationInSeconds,
                _joinChannelPrivilegeExpireInSeconds, _pubAudioPrivilegeExpireInSeconds, _pubVideoPrivilegeExpireInSeconds, _pubDataStreamPrivilegeExpireInSeconds, _account, _tokenExpirationInSeconds);
            AccessToken2 parsed = new AccessToken2();

            Output.WriteLine(">> token");
            Output.WriteLine(token);
            Assert.True(parsed.parse(token));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_RTC));
            Assert.Single(parsed.getServices(AccessToken2.SERVICE_TYPE_RTM));
            Assert.True(parsed.verifySignature(_appCertificate));
        }
    }
}
