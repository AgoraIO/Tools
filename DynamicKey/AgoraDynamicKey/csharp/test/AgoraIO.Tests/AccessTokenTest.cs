using AgoraIO.Media;
using Xunit;

namespace AgoraIO.Tests
{
    public class AccessTokenTest
    {
        private string _appId = "970CA35de60c44645bbae8a215061b33";
        private string _appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string _channelName = "7d72365eb983485397e3e3f9d460bdda";
        private string _uid = "2882341273";
        private uint _ts = 1111111;
        private uint _salt = 1;
        private uint _expiredTs = 1446455471;

        [Fact]
        public void testGenerateDynamicKey()
        {
            string expected = "006970CA35de60c44645bbae8a215061b33IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
            AccessToken token = new AccessToken(_appId, _appCertificate, _channelName, _uid, _ts, _salt);
            token.message.ts = _ts;
            token.message.salt = _salt;
            token.addPrivilege(Privileges.kJoinChannel, _expiredTs);

            string result = token.build();
            Assert.Equal(expected, result);
        }

        //[Fact]
        //public void PackContenxtUnmarshalTest()
        //{
        //    string encodedBase64String = $"IACV0fZUBw+72cVoL9eyGGh3Q6Poi8bgjwVLnyKSJyOXR7dIfRBXoFHlEAABAAAAR/QQAAEAAQCvKDdW";
        //    PackContent packContent = new PackContent();
        //    packContent.unmarshal(new ByteBuf(Convert.FromBase64String(encodedBase64String)));

        //    Console.WriteLine(packContent.signature);
        //}
    }
}
