package io.agora.chat;

import io.agora.media.AccessToken2;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Tests Chat Token007 builder workflows.
 */
public class ChatTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expire = 600;

    /**
     * Verifies Chat user token generation and parsing.
     */
    @Test
    public void testBuildUserToken() {
        ChatTokenBuilder2 chatTokenBuilder = new ChatTokenBuilder2();
        String token = chatTokenBuilder.buildUserToken(appId, appCertificate, userId, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(userId, ((AccessToken2.ServiceChat)accessToken.getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0)).getUserId());
        assertEquals(expire, (int)accessToken.getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0).getPrivileges().get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue));
    }

    /**
     * Verifies Chat application token generation and parsing.
     */
    @Test
    public void testBuildAppToken() {
        ChatTokenBuilder2 chatTokenBuilder = new ChatTokenBuilder2();
        String token = chatTokenBuilder.buildAppToken(appId, appCertificate, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals("", ((AccessToken2.ServiceChat)accessToken.getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0)).getUserId());
        assertEquals(expire, (int)accessToken.getServices(AccessToken2.SERVICE_TYPE_CHAT).get(0).getPrivileges().get(AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP.intValue));
    }
}
