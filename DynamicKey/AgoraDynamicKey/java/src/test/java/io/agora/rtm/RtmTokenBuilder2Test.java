package io.agora.rtm;

import io.agora.media.AccessToken2;
import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Tests RTM Token007 builder workflows.
 */
public class RtmTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expire = 600;

    /**
     * Verifies RTM token generation and parsing.
     */
    @Test
    public void buildToken() {
        RtmTokenBuilder2 rtmTokenBuilder = new RtmTokenBuilder2();
        String token = rtmTokenBuilder.buildToken(appId, appCertificate, userId, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(userId, ((AccessToken2.ServiceRtm)accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0)).getUserId());
        assertEquals(expire, (int)accessToken.getServices(AccessToken2.SERVICE_TYPE_RTM).get(0).getPrivileges().get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }
}
