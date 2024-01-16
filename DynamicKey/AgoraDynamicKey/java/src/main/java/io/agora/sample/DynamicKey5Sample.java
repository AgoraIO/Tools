package io.agora.sample;

import java.util.Date;
import java.util.Random;

import io.agora.media.DynamicKey5;

/**
 * Created by Li on 10/1/2016.
 */
public class DynamicKey5Sample {
    // Need to set environment variable AGORA_APP_ID
    static String appID = System.getenv("AGORA_APP_ID");
    // Need to set environment variable AGORA_APP_CERTIFICATE
    static String appCertificate = System.getenv("AGORA_APP_CERTIFICATE");

    static String channel = "7d72365eb983485397e3e3f9d460bdda";
    static int ts = (int) (new Date().getTime() / 1000);
    static int r = new Random().nextInt();
    static long uid = 2882341273L;
    static int expiredTs = 0;

    public static void main(String[] args) throws Exception {
        System.out.println(DynamicKey5.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
        System.out.println(DynamicKey5.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
        System.out.println(DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid,
                expiredTs, DynamicKey5.noUpload));
        System.out.println(DynamicKey5.generateInChannelPermissionKey(appID, appCertificate, channel, ts, r, uid,
                expiredTs, DynamicKey5.audioVideoUpload));
    }
}
