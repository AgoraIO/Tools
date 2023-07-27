using AgoraIO.Media;
using Xunit;
using System;
using Xunit.Abstractions;
using System.Collections.Generic;

namespace AgoraIO.Tests
{
    public class AccessToken2Test
    {
        private string appId = "970CA35de60c44645bbae8a215061b33";
        private string appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
        private string channelName = "7d72365eb983485397e3e3f9d460bdda";
        private int expire = 600;
        private int issueTs = 1111111;
        private int salt = 1;
        private string uid = "2882341273";
        private string userId = "test_user";

        protected readonly ITestOutputHelper Output;

        public AccessToken2Test(ITestOutputHelper tempOutput)
        {
            Output = tempOutput;
        }

        [Fact]
        public void build()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            Assert.Equal(appCertificate, accessToken._appCert);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            
            string token = accessToken.build();
            Assert.Equal("007eJxTYEiJ9+zw7Gb1viNuGtMfy3JriuZNp+1h1iLu/rOePHlS91WBwdLcwNnR2DQl1cwg2cTEzMQ0KSkx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwgAAKtnGK8=", token);
        }

        [Fact]
        public void build_ServiceRtc()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, expire);
            accessToken.addService(serviceRtc);

            Assert.Equal(channelName, serviceRtc._channelName);
            Assert.Equal(uid, serviceRtc._uid);

            string token = accessToken.build();
            Assert.Equal("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj", token);
        }

        [Fact]
        public void build_ServiceRtc_uid_0()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, "");
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, expire);
            accessToken.addService(serviceRtc);

            Assert.Equal(channelName, serviceRtc._channelName);
            Assert.Equal("", serviceRtc._uid);

            string token = accessToken.build();
            Assert.Equal("007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo=", token);
        }

        [Fact]
        public void build_ServiceRtm()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, expire);

            accessToken.addService(serviceRtm);
            string expected = "007eJxTYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJiBmBPM5GUpSi0viS4tTiwBZVh6A";

            Assert.Equal(expected, accessToken.build());
         }

        [Fact]
        public void build_ServiceChat_userToken()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
            serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_USER, expire);

            accessToken.addService(serviceChat);
            string expected = "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=";

            Assert.Equal(expected, accessToken.build());
        }

        [Fact]
        public void build_ServiceChat_appToken()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat();
            serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_APP, expire);

            accessToken.addService(serviceChat);
            string expected = "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr";

            Assert.Equal(expected, accessToken.build());
        }

        [Fact]
        public void build_multi_service()
        {
            AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
            accessToken._issueTs = issueTs;
            accessToken._salt = salt;

            AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL, expire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM, expire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_VIDEO_STREAM, expire);
            serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_DATA_STREAM, expire);
            accessToken.addService(serviceRtc);

            AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
            serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN, expire);
            accessToken.addService(serviceRtm);

            AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
            serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_USER, expire);
            accessToken.addService(serviceChat);

            Assert.Equal(channelName, serviceRtc._channelName);
            Assert.Equal(uid, serviceRtc._uid);
            Assert.Equal(userId, serviceRtm._userId);

            string expected = "007eJxTYPg19dsX8xO2Nys/bpSeoH/0j9CvSs1JWib9291PKC53l85UYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwAwkWYAYxGcCk8xgkgVMKjCYp5gbGZuZpiZZWhibWJgaW5qnGqcap1mmmJgZJKWkJHIxGFlYGBmbGBqZGzMBzYGYxMlQklpcEl9anFrEChdEVgoAw6ct/Q==";
            string token = accessToken.build();
            Assert.Equal(expected, token);
        }

        [Fact]
        public void parse_TokenRtc()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj");
            Assert.True(res);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            Assert.Equal(1, accessToken._services.Count);

            AccessToken2.ServiceRtc serviceRtc = (AccessToken2.ServiceRtc)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_RTC];
            Dictionary<ushort, uint> privileges = serviceRtc.getPrivileges();

            Assert.Equal(channelName, serviceRtc.getChannelName());
            Assert.Equal(uid, serviceRtc.getUid());
            Assert.Equal(expire, (int)privileges[(ushort)AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL]);

            bool checkOtherPrivilege = privileges.ContainsKey((ushort)AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM);
            Assert.False(checkOtherPrivilege);
        }

        [Fact]
        public void parse_TokenRtc_Rtm_MultiService()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4");
            Assert.True(res);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            Assert.Equal(2, accessToken._services.Count);

            AccessToken2.ServiceRtc serviceRtc = (AccessToken2.ServiceRtc)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_RTC];
            AccessToken2.ServiceRtm serviceRtm = (AccessToken2.ServiceRtm)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_RTM];

            Dictionary<ushort, uint> rtcPrivileges = serviceRtc.getPrivileges();
            Dictionary<ushort, uint> rtmPrivileges = serviceRtm.getPrivileges();

            Assert.Equal(channelName, serviceRtc.getChannelName());
            Assert.Equal(uid, serviceRtc.getUid());
            Assert.Equal(userId, serviceRtm.getUserId());
            Assert.Equal(expire, (int)rtcPrivileges[(ushort)AccessToken2.PrivilegeRtcEnum.PRIVILEGE_JOIN_CHANNEL]);
            
            bool hasAudioStream = rtmPrivileges.ContainsKey((ushort)AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM);
            if (hasAudioStream)
            {
                Assert.Equal(expire, (int)rtmPrivileges[(ushort)AccessToken2.PrivilegeRtcEnum.PRIVILEGE_PUBLISH_AUDIO_STREAM]);
            }
            Assert.Equal(expire, (int)rtmPrivileges[(ushort)AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN]);
        }

        [Fact]
        public void parse_TokenRtm()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A");
            Assert.True(res);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            Assert.Equal(1, accessToken._services.Count);

            AccessToken2.ServiceRtm serviceRtm = (AccessToken2.ServiceRtm)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_RTM];
            Dictionary<ushort, uint> rtmPrivileges = serviceRtm.getPrivileges();

            Assert.Equal(userId, serviceRtm.getUserId());
            Assert.Equal(expire, (int)rtmPrivileges[(ushort)AccessToken2.PrivilegeRtmEnum.PRIVILEGE_LOGIN]);
        }

        [Fact]
        public void parse_TokenChatUser()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=");
            Assert.True(res);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            Assert.Equal(1, accessToken._services.Count);

            AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_CHAT];
            Dictionary<ushort, uint> chatPrivileges = serviceChat.getPrivileges();

            Assert.Equal(uid, serviceChat.getUserId());
            Assert.Equal(expire, (int)chatPrivileges[(ushort)AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_USER]);
        }

        [Fact]
        public void parse_TokenChatApp()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr");
            Assert.True(res);
            Assert.Equal(appId, accessToken._appId);
            Assert.Equal(expire, accessToken._expire);
            Assert.Equal(issueTs, accessToken._issueTs);
            Assert.Equal(salt, accessToken._salt);
            Assert.Equal(1, accessToken._services.Count);

            AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_CHAT];
            Dictionary<ushort, uint> chatPrivileges = serviceChat.getPrivileges();

            Assert.Equal("", serviceChat.getUserId());
            Assert.Equal(expire, (int)chatPrivileges[(ushort)AccessToken2.PrivilegeChatEnum.PRIVILEGE_CHAT_APP]);
        }

        [Fact]
        public void Test_Chat_online_buildUserToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string usrid = "4ac3bae0-6f9e-11ec-8c27-8dc232279082";

            ChatTokenBuilder2 tokenBuilder = new ChatTokenBuilder2();

            string token = tokenBuilder.buildUserToken(appid, appCertificate, usrid, 86400);
            Output.WriteLine($"token: {token}");
        }

        [Fact]
        public void Test_Chat_online_parseUserToken()
        {
            AccessToken2 accessToken = new AccessToken2();
            bool res = accessToken.parse("007eJxTYFDe/EclTsH/38I3/7SO+vMZuAQzPHlqr2Qc6bNUnXmRt6wCQ5phSrK5uUVSSkqymYlZYopFmpGZgaW5WXKiUYqBoWnyxrsHUhoCGRn+VB8pY2RgZWAEQhBfhcEkMdk4KTHVQNcszTJV19AwNVnXItnIXNciJdnI2MjI3NLAwggAHM4nRA==");
            Assert.True(res);

            Output.WriteLine($"appId: {accessToken._appId}");
            Output.WriteLine($"expire: {accessToken._expire}");
            Output.WriteLine($"issueTs: {accessToken._issueTs}");
            Output.WriteLine($"salt: {accessToken._salt}");
            Output.WriteLine($"service count: {accessToken._services.Count}");

            foreach(var it in accessToken._services)
            {
                Output.WriteLine($"service: key:{it.Key}, value:{it.Value}");
            }

            AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat)accessToken._services[(ushort)AccessToken2.SERVICE_TYPE_CHAT];

            Output.WriteLine($"userid: {serviceChat._userId}");

            Dictionary<ushort, uint> chatPrivileges = serviceChat.getPrivileges();

            foreach(var it in chatPrivileges)
            {
                Output.WriteLine($"Chat privilege: key:{it.Key}, value:{it.Value}");
            }
        }

        [Fact]
        public void getUidStr()
        {
            Assert.Equal("", AccessToken2.getUidStr(0));
            Assert.Equal("123", AccessToken2.getUidStr(123));
        }

        [Fact]

        public string RtcToken_buildTokenWithUid1()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string channelName = "rtc_channel";
            int uid = 123;
            RtcTokenBuilder2.Role role = RtcTokenBuilder2.Role.ROLE_PUBLISHER;

            RtcTokenBuilder2 tokenBuilder = new RtcTokenBuilder2();

            string token = tokenBuilder.buildTokenWithUid(appid, appCertificate, channelName, uid, role, 600, 600);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]

        public string RtcToken_buildTokenWithUid2()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string channelName = "rtc_channel";
            int uid = 123;

            RtcTokenBuilder2 tokenBuilder = new RtcTokenBuilder2();

            string token = tokenBuilder.buildTokenWithUid(appid, appCertificate, channelName, uid, 600, 600, 600, 600, 600);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string RtcToken_buildTokenWithUserAccount1()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string channelName = "rtc_channel";
            string account = "my_name";
            RtcTokenBuilder2.Role role = RtcTokenBuilder2.Role.ROLE_PUBLISHER;

            RtcTokenBuilder2 tokenBuilder = new RtcTokenBuilder2();

            string token = tokenBuilder.buildTokenWithUserAccount(appid, appCertificate, channelName, account, role, 600, 600);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string RtcToken_buildTokenWithUserAccount2()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string channelName = "rtc_channel";
            string account = "my_name";

            RtcTokenBuilder2 tokenBuilder = new RtcTokenBuilder2();

            string token = tokenBuilder.buildTokenWithUserAccount(appid, appCertificate, channelName, account, 600, 600, 600, 600, 600);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string RtmToken_buildToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string usrid = "userid";

            RtmTokenBuilder2 tokenBuilder = new RtmTokenBuilder2();

            string token = tokenBuilder.buildToken(appid, appCertificate, usrid, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string ChatToken_buildUserToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string usrid = "4ac3bae0-6f9e-11ec-8c27-8dc232279082";

            ChatTokenBuilder2 tokenBuilder = new ChatTokenBuilder2();

            string token = tokenBuilder.buildUserToken(appid, appCertificate, usrid, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]

        public string ChatToken_buildAppToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";

            ChatTokenBuilder2 tokenBuilder = new ChatTokenBuilder2();

            string token = tokenBuilder.buildAppToken(appid, appCertificate, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string FpaToken_buildToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";

            FpaTokenBuilder2 tokenBuilder = new FpaTokenBuilder2();

            string token = tokenBuilder.buildToken(appid, appCertificate);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string EducationToken_buildRoomUserToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string roomId = "12345678-6f9e-11ec-8c27-8dc232279082";
            string userId = "4ac3bae0-6f9e-11ec-8c27-8dc232279082";
            //The user's role, such as 0(invisible), 1(teacher), 2(student), 3(assistant), 4(observer) etc.
            short role = 1;

            EducationTokenBuilder2 tokenBuilder = new EducationTokenBuilder2();

            string token = tokenBuilder.buildRoomUserToken(appid, appCertificate, roomId, userId, role, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string EducationToken_buildUserToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";
            string userId = "4ac3bae0-6f9e-11ec-8c27-8dc232279082";

            EducationTokenBuilder2 tokenBuilder = new EducationTokenBuilder2();

            string token = tokenBuilder.buildUserToken(appid, appCertificate, userId, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }

        [Fact]
        public string EducationToken_buildAppToken()
        {
            string appid = "f1dc778bddc646ad8f260976ca2d015c";
            string appCertificate = "b5a23fd8013a4db8bb06f7d1e26da789";

            EducationTokenBuilder2 tokenBuilder = new EducationTokenBuilder2();

            string token = tokenBuilder.buildAppToken(appid, appCertificate, 86400);
            Output.WriteLine($"token : {token}");
            return token;
        }
    }
}
