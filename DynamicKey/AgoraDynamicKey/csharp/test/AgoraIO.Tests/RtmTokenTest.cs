using AgoraIO.Media;
using AgoraIO.Rtm;
using Xunit;

namespace AgoraIO.Tests
{
    public class RtmTokenTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _uid = "test_user";
        private uint _expiredTs = 1446455471;

        [Fact]
        public void testRtmToken()
        {
            RtmTokenBuilder builder = new RtmTokenBuilder();
            string result = builder.buildToken(this._appId, this._appCertificate, this._uid, this._expiredTs);

            RtmTokenBuilder tester = new RtmTokenBuilder();
            tester.mTokenCreator = new AccessToken("", "", "", "");
            tester.mTokenCreator.fromString(result);

            Assert.Equal(builder.mTokenCreator._appId, tester.mTokenCreator._appId);
            Assert.Equal(builder.mTokenCreator._crcChannelName, tester.mTokenCreator._crcChannelName);
            Assert.Equal(builder.mTokenCreator._salt, tester.mTokenCreator._salt);
        }

    }
}