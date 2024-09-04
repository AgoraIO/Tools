package io.agora.education;

import static org.junit.Assert.assertEquals;
import org.junit.Test;
import io.agora.media.AccessToken2;

public class EducationTokenBuilder2Test {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private static String roomUuid = "123";
    private static String userUuid = "2882341273";
    private static Short role = 1;
    private static int expire = 600;

    private static Short defaultRole = -1;
    private static String defaultRoomUuid = "";
    private static String defaultUserUuid = "";

    @Test
    public void testBuildRoomUserToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(roomUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRoomUuid());
        assertEquals(userUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getUserUuid());
        assertEquals(role, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRole());
    }

    @Test
    public void testBuildUserToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildUserToken(appId, appCertificate, userUuid, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(defaultRoomUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRoomUuid());
        assertEquals(userUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getUserUuid());
        assertEquals(defaultRole, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRole());
    }

    @Test
    public void testBuildAppToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildAppToken(appId, appCertificate, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);

        assertEquals(appId, accessToken.appId);
        assertEquals(expire, accessToken.expire);
        assertEquals(defaultRoomUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRoomUuid());
        assertEquals(defaultUserUuid, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getUserUuid());
        assertEquals(defaultRole, ((AccessToken2.ServiceApaas) accessToken.services.get(AccessToken2.SERVICE_TYPE_APAAS)).getRole());
    }
}
