package io.agora.sample;

import io.agora.rtm.RtmTokenBuilder2;

public class RtmTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    private static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    private static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    private static String userId = "test_user_id";
    private static int expirationInSeconds = 3600;

    public static void main(String[] args) {
        RtmTokenBuilder2 token = new RtmTokenBuilder2();
        String result = token.buildToken(appId, appCertificate, userId, expirationInSeconds);
        System.out.println("Rtm Token: " + result);
    }
}
