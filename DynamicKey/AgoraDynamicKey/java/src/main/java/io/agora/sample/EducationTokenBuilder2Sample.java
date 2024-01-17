package io.agora.sample;

import io.agora.education.EducationTokenBuilder2;

public class EducationTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    private static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    private static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    private static String roomUuid = "123";
    private static String userUuid = "2882341273";
    private static Short role = 1;
    private static int expire = 600;

    public static void main(String[] args) {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        EducationTokenBuilder2 tokenBuilder = new EducationTokenBuilder2();
        String roomUserToken = tokenBuilder.buildRoomUserToken(appId, appCertificate, roomUuid, userUuid, role, expire);
        System.out.printf("Education room user token: %s\n", roomUserToken);

        String userToken = tokenBuilder.buildUserToken(appId, appCertificate, userUuid, expire);
        System.out.printf("Education user token: %s\n", userToken);

        String appToken = tokenBuilder.buildAppToken(appId, appCertificate, expire);
        System.out.printf("Education app token: %s\n", appToken);
    }
}
