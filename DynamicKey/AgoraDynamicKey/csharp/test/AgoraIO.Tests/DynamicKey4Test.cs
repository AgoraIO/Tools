using AgoraIO.Media;
using System;
using Xunit;
using Xunit.Abstractions;

namespace AgoraIO.Tests
{
    public class DynamicKey4Test
    {
        String appID = "b9b595bcfd72479d894abe7a8cf0c37e";
        String appCertificate = "3c481e60aac14b06a434a20e70de7c51";
        String channel = "7d72365eb983485397e3e3f9d460bdda";

        protected readonly ITestOutputHelper Output;

        public DynamicKey4Test(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        [Fact]
        public void testGeneratePublicSharingKey() //throws Exception
        {
            int ts = 1446455472;
            int r = 58964981;
            string uid = 2882341273L.ToString();
            int expiredTs = 1446455471;

            String expected = "0047f60ef0a65df9aad718eb6c4790a3e52a468313bb9b595bcfd72479d894abe7a8cf0c37e14464554720383bbf51446455471";
            String token = DynamicKey4.generatePublicSharingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
            Output.WriteLine($"token : {token}");
            Assert.Equal(expected, token);
        }

        [Fact]
        public void testGenerateRecordingKey() //throws Exception
        {
            int ts = 1446455472;
            int r = 58964981;
            string uid = 2882341273L.ToString();
            int expiredTs = 1446455471;

            String expected = "004d77264727a82bbbeac5c65cc125cda2992ad2106b9b595bcfd72479d894abe7a8cf0c37e14464554720383bbf51446455471";
            String token = DynamicKey4.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
            Output.WriteLine($"token : {token}");
            Assert.Equal(expected, token);
        }

        [Fact]
        public void testGenerateMediaChannelKey() //throws Exception
        {
            int ts = 1446455472;
            int r = 58964981;
            string uid = 2882341273L.ToString();
            int expiredTs = 1446455471;

            String expected = "004d4bcd4be9daabe83581b93336313a97c696b0b0bb9b595bcfd72479d894abe7a8cf0c37e14464554720383bbf51446455471";
            String token = DynamicKey4.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
            Output.WriteLine($"token : {token}");
            Assert.Equal(expected, token);
        }
    }
}
