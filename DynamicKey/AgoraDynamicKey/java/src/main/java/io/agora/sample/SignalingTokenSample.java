package io.agora.sample;

import java.security.NoSuchAlgorithmException;
import java.util.Date;

import io.agora.signal.SignalingToken;

public class SignalingTokenSample {
    public static void main(String[] args) throws NoSuchAlgorithmException {
        // Need to set environment variable AGORA_APP_ID
        String appId = System.getenv("AGORA_APP_ID");
        // Need to set environment variable AGORA_APP_CERTIFICATE
        String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

        String account = "TestAccount";
        // Use the current time plus an available time to guarantee the only time it is
        // obtained
        int expiredTsInSeconds = 1446455471 + (int) (new Date().getTime() / 1000l);

        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        String result = SignalingToken.getToken(appId, appCertificate, account, expiredTsInSeconds);
        System.out.printf("Token: %s\n", result);
    }
}
