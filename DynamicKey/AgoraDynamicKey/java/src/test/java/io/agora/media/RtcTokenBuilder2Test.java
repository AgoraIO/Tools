package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.*;

public class RtcTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String channelName = "7d72365eb983485397e3e3f9d460bdda";
    private int expire = 600;
    private int uid = 2147483647;
    private String uidStr = "2147483647";

    @Test
    public void buildTokenWithUid_ROLE_PUBLISHER() {
        RtcTokenBuilder2 rtcTokenBuilder = new RtcTokenBuilder2();
        String token = rtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, RtcTokenBuilder2.Role.ROLE_PUBLISHER, expire, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getChannelName());
        assertEquals(uidStr, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue));
    }

    @Test
    public void buildTokenWithUserAccount_ROLE_PUBLISHER() {
        RtcTokenBuilder2 rtcTokenBuilder = new RtcTokenBuilder2();
        String token = rtcTokenBuilder.buildTokenWithUserAccount(appId, appCertificate, channelName, uidStr, RtcTokenBuilder2.Role.ROLE_PUBLISHER, expire, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getChannelName());
        assertEquals(uidStr, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue));
    }

    @Test
    public void buildTokenWithUserAccount_ROLE_SUBSCRIBER() {
        RtcTokenBuilder2 rtcTokenBuilder = new RtcTokenBuilder2();
        String token = rtcTokenBuilder.buildTokenWithUserAccount(appId, appCertificate, channelName, uidStr, RtcTokenBuilder2.Role.ROLE_SUBSCRIBER, expire, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getChannelName());
        assertEquals(uidStr, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(0, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue, 0));
        assertEquals(0, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM.intValue, 0));
        assertEquals(0, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().getOrDefault(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue, 0));
    }

    @Test
    public void buildTokenWithUid_privilege() {
        RtcTokenBuilder2 rtcTokenBuilder = new RtcTokenBuilder2();
        String token = rtcTokenBuilder.buildTokenWithUid(appId, appCertificate, channelName, uid, expire, expire, expire, expire, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getChannelName());
        assertEquals(uidStr, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue));
    }

    @Test
    public void buildTokenWithUserAccount_privilege() {
        RtcTokenBuilder2 rtcTokenBuilder = new RtcTokenBuilder2();
        String token = rtcTokenBuilder.buildTokenWithUserAccount(appId, appCertificate, channelName, uidStr, expire, expire, expire, expire, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(channelName, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getChannelName());
        assertEquals(uidStr, ((AccessToken2.ServiceRtc) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC)).getUid());
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_AUDIO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_VIDEO_STREAM.intValue));
        assertEquals(expire, (int) accessToken.services.get(AccessToken2.SERVICE_TYPE_RTC).getPrivileges().get(AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue));
    }
}