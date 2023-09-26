package io.agora.media;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class AccessToken2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String channelName = "7d72365eb983485397e3e3f9d460bdda";
    private int expire = 600;
    private int issueTs = 1111111;
    private int salt = 1;
    private String uid = "2882341273";
    private String userId = "test_user";

    @Test
    public void build() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        assertEquals(appCertificate, accessToken.appCert);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYEiJ9+zw7Gb1viNuGtMfy3JriuZNp+1h1iLu/rOePHlS91WBwdLcwNnR2DQl1cwg2cTEzMQ0KSkx1SLRyNDUwMwwydjY/YsAQwQTAwMjAwgAAKtnGK8=",
                token);
    }

    @Test
    public void build_ServiceRtc() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
                token);
    }

    @Test
    public void build_ServiceRtc_uid_0() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, "");
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals("", serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYLhzZP08Lxa1Pg57+TcXb/3cZ3wi4V6kbpbOog0G2dOYk20UGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiQwMADacImo=",
                token);
    }

    @Test
    public void build_ServiceRtc_account() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        accessToken.addService(serviceRtc);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);

        String token = accessToken.build();
        assertEquals(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj",
                token);
    }

    @Test
    public void build_ServiceRtm() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);

        accessToken.addService(serviceRtm);
        String expected = "007eJxTYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJiBmBPM5GUpSi0viS4tTiwBZVh6A";

        assertEquals(expected, accessToken.build());
    }

    @Test
    public void build_ServiceChat_userToken() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);

        accessToken.addService(serviceChat);
        String expected = "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=";

        assertEquals(expected, accessToken.build());
    }

    @Test
    public void build_ServiceChat_appToken() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat();
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP, expire);

        accessToken.addService(serviceChat);
        String expected = "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr";

        assertEquals(expected, accessToken.build());
    }

    @Test
    public void build_multi_service() throws Exception {
        AccessToken2 accessToken = new AccessToken2(appId, appCertificate, expire);
        accessToken.issueTs = issueTs;
        accessToken.salt = salt;

        AccessToken2.ServiceRtc serviceRtc = new AccessToken2.ServiceRtc(channelName, uid);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM, expire);
        serviceRtc.addPrivilegeRtc(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM, expire);
        accessToken.addService(serviceRtc);

        AccessToken2.ServiceRtm serviceRtm = new AccessToken2.ServiceRtm(userId);
        serviceRtm.addPrivilegeRtm(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN, expire);
        accessToken.addService(serviceRtm);

        AccessToken2.ServiceChat serviceChat = new AccessToken2.ServiceChat(uid);
        serviceChat.addPrivilegeChat(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER, expire);
        accessToken.addService(serviceChat);

        assertEquals(channelName, serviceRtc.channelName);
        assertEquals(uid, serviceRtc.uid);
        assertEquals(userId, serviceRtm.userId);

        String expected = "007eJxTYPg19dsX8xO2Nys/bpSeoH/0j9CvSs1JWib9291PKC53l85UYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyMDAwAwkWYAYxGcCk8xgkgVMKjCYp5gbGZuZpiZZWhibWJgaW5qnGqcap1mmmJgZJKWkJHIxGFlYGBmbGBqZGzMBzYGYxMlQklpcEl9anFrEChdEVgoAw6ct/Q==";
        String token = accessToken.build();
        assertEquals(expected, token);
    }

    @Test
    public void parse_TokenRtc() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYBBbsMMnKq7p9Hf/HcIX5kce9b518kCiQgSr5Zrp4X1Tu6UUGCzNDZwdjU1TUs0Mkk1MzExMk5ISUy0SjQxNDcwMk4yN3b8IMEQwMTAwMoAwBIL4CgzmKeZGxmamqUmWFsYmFqbGluapxqnGaZYpJmYGSSkpiVwMRhYWRsYmhkbmxgDCaiTj");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTC))
                .getChannelName());
        assertEquals(uid, ((AccessToken2.ServiceRtc) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(0, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)
                .getPrivileges()
                .getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue, 0));
    }

    @Test
    public void parse_TokenRtc_error() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse("007eJxTYLC/xv0i87343FLb46KrG9gPxT+Vj8pojqvt");

        assertFalse(res);
        assertEquals("", accessToken.appId);
        assertEquals(0, accessToken.expire);
        assertEquals(0, accessToken.issueTs);
        assertEquals(0, accessToken.salt);
        assertEquals(0, accessToken.services.size());
    }

    @Test
    public void parse_TokenRtc_Rtm_MultiService() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYOAQsrQ5s3TfH+1tvy8zZZ46EpCc0V43JXdGd2jS8porKo4KDJbmBs6OxqYpqWYGySYmZiamSUmJqRaJRoamBmaGScbG7l8EGCKYGBgYGRgYmIAkCxCD+ExgkhlMsoBJBQbzFHMjYzPT1CRLC2MTC1NjS/NU41TjNMsUEzODpJSURC4GIwsLI2MTQyNzY5BZEJM4GUpSi0viS4tTiwAipyp4");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(2, accessToken.services.size());
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTC))
                .getChannelName());
        assertEquals(uid, ((AccessToken2.ServiceRtc) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(userId, ((AccessToken2.ServiceRtm) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTM)).getUserId());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)
                .getPrivileges()
                .getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue, 0));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTM)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }

    @Test
    public void parse_TokenRtm() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxSYOCdJftjyTM2zxW6Xhm/5T0j5LdcUt/xYVt48fb5Mp3PX9coMFiaGzg7GpumpJoZJJuYmJmYJiUlplokGhmaGpgZJhkbu38RYIhgYmBgZABhJgZGBkYwn5OhJLW4JL60OLUIEAAA//9ZVh6A");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        assertEquals(userId, ((AccessToken2.ServiceRtm) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_RTM)).getUserId());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTM)
                .getPrivileges()
                .get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }

    @Test
    public void parse_TokenChatUser() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYNAIsnbS3v/A5t2TC6feR15r+6cq8bqAvfaW+tk/Vzz+p6xTYLA0N3B2NDZNSTUzSDYxMTMxTUpKTLVINDI0NTAzTDI2dv8iwBDBxMDAyADCrEDMCOZzMRhZWBgZmxgamRsDAB+lHrg=");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_CHAT);
        assertEquals(uid, serviceChat.getUserId());
        assertEquals(expire, (int) serviceChat.getPrivileges()
                .get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue));
    }

    @Test
    public void parse_TokenChatApp() {
        AccessToken2 accessToken = new AccessToken2();
        boolean res = accessToken.parse(
                "007eJxTYNDNaz3snC8huEfHWdz6s98qltq4zqy9fl99Uh0FDvy6F6DAYGlu4OxobJqSamaQbGJiZmKalJSYapFoZGhqYGaYZGzs/kWAIYKJgYGRAYRZgZgJzGdgAACt8hhr");
        assertTrue(res);
        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(issueTs, accessToken.issueTs);
        assertEquals(salt, accessToken.salt);
        assertEquals(1, accessToken.services.size());
        AccessToken2.ServiceChat serviceChat = (AccessToken2.ServiceChat) accessToken.services
                .get(AccessToken2.SERVICE_TYPE_CHAT);
        assertEquals("", serviceChat.getUserId());
        assertEquals(expire, (int) serviceChat.getPrivileges()
                .get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP.intValue));
    }

    @Test
    public void getUidStr() {
        assertEquals("", AccessToken2.getUidStr(0));
        assertEquals("123", AccessToken2.getUidStr(123));
    }
}
