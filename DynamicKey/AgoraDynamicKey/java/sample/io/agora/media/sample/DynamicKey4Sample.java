package io.agora.media.sample;

import io.agora.media.DynamicKey4;

import java.util.Date;
import java.util.Random;

/**
 * Created by liwei on 5/14/16.
 */

public class DynamicKey4Sample {
    static String appID   = "970ca35de60c44645bbae8a215061b33";
    static String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
    static String channel  = "7d72365eb983485397e3e3f9d460bdda";
    static int ts = (int)(new Date().getTime()/1000);
    static int r = new Random().nextInt();
    static long uid = 2882341273L;
    static int expiredTs = 0;

    public static void main(String[] args) throws Exception {
        System.out.println(DynamicKey4.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
        System.out.println(DynamicKey4.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs));
    }
}
