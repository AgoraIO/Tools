package io.agora.sample;

import java.security.NoSuchAlgorithmException;
import java.util.Date;

import io.agora.signal.SignalingToken;

public class SignalingTokenSample {
    public static void main(String[] args) throws NoSuchAlgorithmException {
        // Need to set environment variable AGORA_APP_ID
        String appId = System.getenv("AGORA_APP_ID");
        // Need to set environment variable AGORA_APP_CERTIFICATE
        String certificate = System.getenv("AGORA_APP_CERTIFICATE");

        String account = "TestAccount";
        // Use the current time plus an available time to guarantee the only time it is
        // obtained
        int expiredTsInSeconds = 1446455471 + (int) (new Date().getTime() / 1000l);
        String result = SignalingToken.getToken(appId, certificate, account, expiredTsInSeconds);
        System.out.println(result);
    }
}
