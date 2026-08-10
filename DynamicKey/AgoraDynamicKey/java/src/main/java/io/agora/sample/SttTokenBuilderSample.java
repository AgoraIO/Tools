package io.agora.sample;

import io.agora.media.RtcTokenBuilder2;
import io.agora.media.SttTokenBuilder;

public class SttTokenBuilderSample {
    public static void main(String[] args) {
        String appId = System.getenv("AGORA_APP_ID");
        String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

        String channelName = "stt-channel";
        String rtcAccount = "stt-rtc-user";
        int rtcTokenExpire = 3600;
        int joinChannelPrivilegeExpire = 3600;
        int pubAudioPrivilegeExpire = 3600;
        int pubVideoPrivilegeExpire = 3600;
        int pubDataStreamPrivilegeExpire = 3600;
        String rtmUserId = "stt-rtm-user";
        int rtmTokenExpire = 3600;

        System.out.println("App Id: " + appId);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE");
            return;
        }

        String token = SttTokenBuilder.buildToken(
                appId,
                appCertificate,
                channelName,
                rtcAccount,
                RtcTokenBuilder2.Role.ROLE_PUBLISHER,
                rtcTokenExpire,
                joinChannelPrivilegeExpire,
                pubAudioPrivilegeExpire,
                pubVideoPrivilegeExpire,
                pubDataStreamPrivilegeExpire,
                rtmUserId,
                rtmTokenExpire
        );
        System.out.println("STT token: " + token);
    }
}
