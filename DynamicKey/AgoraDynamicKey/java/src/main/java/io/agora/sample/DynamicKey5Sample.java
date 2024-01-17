package io.agora.sample;

import java.util.Date;
import java.util.Random;

import io.agora.media.DynamicKey5;

/**
 * Created by Li on 10/1/2016.
 */
public class DynamicKey5Sample {
    // Need to set environment variable AGORA_APP_ID
    static String appId = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    static String channel = "7d72365eb983485397e3e3f9d460bdda";
    static int ts = (int) (new Date().getTime() / 1000);
    static int r = new Random().nextInt();
    static long uid = 2882341273L;
    static int expiredTs = 0;

    public static void main(String[] args) throws Exception {
        System.out.printf("App Id: %s\n", appId);
        System.out.printf("App Certificate: %s\n", appCertificate);
        if (appId == null || appId.isEmpty() || appCertificate == null || appCertificate.isEmpty()) {
            System.out.printf("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE\n");
            return;
        }

        System.out.println(DynamicKey5.generateMediaChannelKey(appId, appCertificate, channel, ts, r, uid, expiredTs));
        System.out.println(DynamicKey5.generateRecordingKey(appId, appCertificate, channel, ts, r, uid, expiredTs));
        System.out.println(DynamicKey5.generateInChannelPermissionKey(appId, appCertificate, channel, ts, r, uid,
                expiredTs, DynamicKey5.noUpload));
        System.out.println(DynamicKey5.generateInChannelPermissionKey(appId, appCertificate, channel, ts, r, uid,
                expiredTs, DynamicKey5.audioVideoUpload));
    }
}
