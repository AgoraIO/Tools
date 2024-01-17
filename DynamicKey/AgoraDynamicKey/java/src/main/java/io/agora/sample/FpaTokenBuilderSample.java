package io.agora.sample;

import io.agora.media.FpaTokenBuilder;

public class FpaTokenBuilderSample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    public static void main(String[] args) {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        FpaTokenBuilder token = new FpaTokenBuilder();
        String result = token.buildToken(appId, appCertificate);
        System.out.printf("Token with FPA service: %s\n", result);
    }
}
