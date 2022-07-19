using AgoraIO.Media;
using System;
using Xunit;

namespace AgoraIO.Tests
{
    public class SignalingTokenTest
    {
        [Fact]
        public void testSignalingToken()// throws NoSuchAlgorithmException
        {

            String appId = "970ca35de60c44645bbae8a215061b33";
            String certificate = "5cfd2fd1755d40ecb72977518be15d3b";
            String account = "TestAccount";
            int expiredTsInSeconds = 1446455471;
            String expected = "1:970ca35de60c44645bbae8a215061b33:1446455471:4815d52c4fd440bac35b981c12798774";
            String result = SignalingToken.getToken(appId, certificate, account, expiredTsInSeconds);
            Assert.Equal(expected, result);

        }
    }
}
