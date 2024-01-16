package io.agora.sample;

import io.agora.media.FpaTokenBuilder;

public class FpaTokenBuilderSample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    public static void main(String[] args) {
        FpaTokenBuilder token = new FpaTokenBuilder();
        String result = token.buildToken(appId, appCertificate);
        System.out.println("Token with FPA service: " + result);
    }
}
