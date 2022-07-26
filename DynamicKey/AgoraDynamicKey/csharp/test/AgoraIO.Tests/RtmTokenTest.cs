using AgoraIO.Media;
using Xunit;
using Xunit.Abstractions;

namespace AgoraIO.Tests
{
    public class RtmTokenTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _uid = "2882341273";
        private uint _expireTimeInSeconds = 3600;
        private uint _salt = 1;
        protected readonly ITestOutputHelper Output;

        public RtmTokenTest(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        [Fact]
        public void test()
        {
            uint privilegeExpiredTs = _expireTimeInSeconds + (uint)Utils.getTimestamp();
            AccessToken accessToken = new AccessToken(_appId, _appCertificate, _uid, "", privilegeExpiredTs, _salt);
            accessToken.addPrivilege(Privileges.kRtmLogin, privilegeExpiredTs);
            string token = accessToken.build();
            Output.WriteLine(">> token");
            Output.WriteLine(token);
        }
    }
}