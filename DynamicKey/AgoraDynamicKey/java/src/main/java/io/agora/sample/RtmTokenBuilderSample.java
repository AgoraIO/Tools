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
        RtmTokenBuilder token = new RtmTokenBuilder();
        String result = token.buildToken(appId, appCertificate, userId, Role.Rtm_User, expireTimestamp);
        System.out.println(result);
    }
}
