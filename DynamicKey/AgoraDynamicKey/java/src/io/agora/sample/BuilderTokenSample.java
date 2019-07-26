package io.agora.sample;

import io.agora.media.RtcTokenBuilder;
import io.agora.media.RtcTokenBuilder.Role;

public class BuilderTokenSample {
    static String appId = "970CA35de60c44645bbae8a215061b33";
    static String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    static String channelName = "7d72365eb983485397e3e3f9d460bdda";
    static String uid = "2882341273";
    static int expireTimestamp = 0;

    public static void main(String[] args) throws Exception {
        RtcTokenBuilder token = new RtcTokenBuilder();
        String result = token.buildTokenWithUserAccount(appId, appCertificate, 
        		channelName, uid, Role.Role_Publisher, expireTimestamp);
        System.out.println(result);
    }
}
