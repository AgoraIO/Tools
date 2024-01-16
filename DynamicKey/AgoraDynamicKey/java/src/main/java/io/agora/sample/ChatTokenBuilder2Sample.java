package io.agora.sample;

import io.agora.chat.ChatTokenBuilder2;

public class ChatTokenBuilder2Sample {
    // Need to set environment variable AGORA_APP_ID
    private static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    private static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    private static String userId = "2882341273";
    private static int expire = 600;

    public static void main(String[] args) throws Exception {
        ChatTokenBuilder2 tokenBuilder = new ChatTokenBuilder2();
        String userToken = tokenBuilder.buildUserToken(appId, appCertificate, userId, expire);
        System.out.printf("Chat user token: %s\n", userToken);
        String appToken = tokenBuilder.buildAppToken(appId, appCertificate, expire);
        System.out.printf("Chat app token: %s\n", appToken);
    }
}
