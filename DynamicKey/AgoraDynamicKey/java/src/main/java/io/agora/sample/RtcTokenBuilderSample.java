package io.agora.sample;

import io.agora.media.RtcTokenBuilder;
import io.agora.media.RtcTokenBuilder.Role;

public class RtcTokenBuilderSample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    static String channelName = "7d72365eb983485397e3e3f9d460bdda";
    static String userAccount = "2082341273";
    static int uid = 2082341273;
    static int expirationTimeInSeconds = 3600;

    public static void main(String[] args) throws Exception {
        RtcTokenBuilder token = new RtcTokenBuilder();
        int timestamp = (int) (System.currentTimeMillis() / 1000 + expirationTimeInSeconds);
        String result = token.buildTokenWithUserAccount(appId, appCertificate,
                channelName, userAccount, Role.Role_Publisher, timestamp);
        System.out.println(result);

        result = token.buildTokenWithUid(appId, appCertificate,
                channelName, uid, Role.Role_Publisher, timestamp);
        System.out.println(result);
    }
}
