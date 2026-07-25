package io.agora.rtm;

import io.agora.media.AccessToken2;
import java.util.Arrays;
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

    /**
     * Verifies RTM2 permission token generation, parsing, and signature validation.
     */
    @Test
    public void buildTokenWithPermissions() {
        AccessToken2.ServiceRtm2.Permissions permissions = new AccessToken2.ServiceRtm2.Permissions();
        permissions.add(AccessToken2.ServiceRtm2.Permissions.MESSAGE_CHANNELS,
                AccessToken2.ServiceRtm2.Permissions.READ, Arrays.asList("message-a", "message-b"));
        permissions.add(AccessToken2.ServiceRtm2.Permissions.STREAM_CHANNELS,
                AccessToken2.ServiceRtm2.Permissions.WRITE, Arrays.asList("stream-a"));

        RtmTokenBuilder2 builder = new RtmTokenBuilder2();
        String token = builder.buildTokenWithPermissions(appId, appCertificate, userId, permissions, expire);
        AccessToken2 parser = new AccessToken2();

        assertTrue(parser.parse(token));
        assertTrue(parser.verifySignature(appCertificate));
        AccessToken2.ServiceRtm2 service = (AccessToken2.ServiceRtm2)
                parser.getServices(AccessToken2.SERVICE_TYPE_RTM2).get(0);
        assertEquals(userId, service.userId);
        assertEquals(permissions.details, service.permissions.details);
        assertEquals(expire, (int) service.privileges.get(AccessToken2.PrivilegeRtm2.PRIVILEGE_LOGIN.intValue));
    }
}
