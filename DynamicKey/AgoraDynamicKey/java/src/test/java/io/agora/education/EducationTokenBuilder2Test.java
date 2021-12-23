package io.agora.education;

import io.agora.media.AccessToken2;
import org.junit.Test;

import static org.junit.Assert.*;

public class EducationTokenBuilder2Test {
    private static String appId = "f488493d1886435f963dfb3d95984fd4";
    private static String appCertificate = "d89d2a4409144ecca7612237f19ccce6";
    private static String roomUuid = "123";
    private static String userUuid = "2882341273";
    private static Integer role = 1;
    private static int expire = 600;

    @Test
    public void testBuildRoomUserToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);
    }

    @Test
    public void testBuildUserToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildUserToken(appId, appCertificate, userUuid, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);
    }

    @Test
    public void testBuildAppToken() {
        EducationTokenBuilder2 educationTokenBuilder2 = new EducationTokenBuilder2();
        String token = educationTokenBuilder2.buildAppToken(appId, appCertificate, expire);
        AccessToken2 accessToken = new AccessToken2();
        accessToken.parse(token);
    }
}