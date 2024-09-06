package io.agora.sample;

import io.agora.media.RtcTokenBuilder2;
import io.agora.media.RtcTokenBuilder2.Role;

public class RtcTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    static String channelName = "7d72365eb983485397e3e3f9d460bdda";
    static String account = "2082341273";
    static int uid = 2082341273;
    static int tokenExpirationInSeconds = 3600;
    static int privilegeExpirationInSeconds = 3600;
    static int joinChannelPrivilegeExpireInSeconds = 3600;
    static int pubAudioPrivilegeExpireInSeconds = 3600;
    static int pubVideoPrivilegeExpireInSeconds = 3600;
    static int pubDataStreamPrivilegeExpireInSeconds = 3600;

    public static void main(String[] args) {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        RtcTokenBuilder2 token = new RtcTokenBuilder2();
        String result =
                token.buildTokenWithUid(appId, appCertificate, channelName, uid, Role.ROLE_PUBLISHER, tokenExpirationInSeconds, privilegeExpirationInSeconds);
        System.out.printf("Token with uid: %s\n", result);

        result = token.buildTokenWithUserAccount(appId, appCertificate, channelName, account, Role.ROLE_PUBLISHER, tokenExpirationInSeconds,
                privilegeExpirationInSeconds);
        System.out.printf("Token with account: %s\n", result);

        result = token.buildTokenWithUid(appId, appCertificate, channelName, uid, tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds,
                pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds);
        System.out.printf("Token with uid and privilege: %s\n", result);

        result = token.buildTokenWithUserAccount(appId, appCertificate, channelName, account, tokenExpirationInSeconds, joinChannelPrivilegeExpireInSeconds,
                pubAudioPrivilegeExpireInSeconds, pubVideoPrivilegeExpireInSeconds, pubDataStreamPrivilegeExpireInSeconds);
        System.out.printf("Token with account and privilege: %s\n", result);

        result = token.buildTokenWithRtm(appId, appCertificate, channelName, account, Role.ROLE_PUBLISHER, tokenExpirationInSeconds,
                privilegeExpirationInSeconds);
        System.out.printf("Token with RTM: %s\n", result);

    }
}
