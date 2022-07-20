package io.agora.chat;

import io.agora.media.AccessToken2;
import org.junit.Test;

import static org.junit.Assert.*;

public class ChatTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expire = 600;

    @Test
    public void testBuildUserToken() {
        ChatTokenBuilder2 chatTokenBuilder = new ChatTokenBuilder2();
        String token = chatTokenBuilder.buildUserToken(appId, appCertificate, userId, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(userId, ((AccessToken2.ServiceChat)accessToken.services.get(AccessToken2.SERVICE_TYPE_CHAT)).getUserId());
        assertEquals(expire, (int)accessToken.services.get(AccessToken2.SERVICE_TYPE_CHAT).getPrivileges().get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue));
    }

    @Test
    public void testBuildAppToken() {
        ChatTokenBuilder2 chatTokenBuilder = new ChatTokenBuilder2();
        String token = chatTokenBuilder.buildAppToken(appId, appCertificate, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals("", ((AccessToken2.ServiceChat)accessToken.services.get(AccessToken2.SERVICE_TYPE_CHAT)).getUserId());
        assertEquals(expire, (int)accessToken.services.get(AccessToken2.SERVICE_TYPE_CHAT).getPrivileges().get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP.intValue));
    }
}