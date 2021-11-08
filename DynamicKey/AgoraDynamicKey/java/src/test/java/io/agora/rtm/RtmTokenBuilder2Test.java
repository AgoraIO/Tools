package io.agora.rtm;

import io.agora.media.AccessToken2;
import org.junit.Test;

import static org.junit.Assert.*;

public class RtmTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expire = 600;

    @Test
    public void buildToken() {
        RtmTokenBuilder2 rtmTokenBuilder = new RtmTokenBuilder2();
        String token = rtmTokenBuilder.buildToken(appId, appCertificate, userId, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(userId, ((AccessToken2.ServiceRtm)accessToken.services.get(AccessToken2.SERVICE_TYPE_RTM)).getUserId());
        assertEquals(expire, (int)accessToken.services.get(AccessToken2.SERVICE_TYPE_RTM).getPrivileges().get(AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue));
    }
}