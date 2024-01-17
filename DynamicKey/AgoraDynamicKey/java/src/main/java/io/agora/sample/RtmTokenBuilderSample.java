package io.agora.sample;

import io.agora.rtm.RtmTokenBuilder;
import io.agora.rtm.RtmTokenBuilder.Role;

public class RtmTokenBuilderSample {
    // Need to set environment variable AGORA_APP_ID
    private static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    private static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    private static String userId = "2882341273";
    private static int expireTimestamp = 0;

    public static void main(String[] args) throws Exception {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        RtmTokenBuilder token = new RtmTokenBuilder();
        String result = token.buildToken(appId, appCertificate, userId, Role.Rtm_User, expireTimestamp);
        System.out.printf("Rtm Token: %s\n", result);
    }
}
