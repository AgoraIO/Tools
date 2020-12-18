using AgoraIO.Media;
using Xunit;

namespace AgoraIO.Tests
{
    public class RtmTokenTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _uid = "2882341273";
        private uint _expiredTs = 0;
        private uint _ts = 1111111;
        private uint _salt = 1;

        [Fact]
        public void testRtmToken()
        {
            string expected = "006970CA35de60c44645bbae8a215061b33IAB/luJx7c3zCxag46cPAwofHXnoslvPjP1rvRJIgxemHFegUeUAAAAAEAABAAAAR/QQAAEA6AMAAAAA";
            AccessToken token = new AccessToken(_appId, _appCertificate, _uid, "", _ts, _salt);
            token.message.ts = _ts;
            token.message.salt = _salt;
            token.addPrivilege(Privileges.kRtmLogin, _expiredTs);
            string result = token.build();
            Assert.Equal(expected, result);
        }
        
    }
}
