package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by liwei on 5/4/16.
 */
public class DynamicKey4Test {
    @Test
    public void testGeneratePublicSharingKey() throws Exception {
        String appID   = "970ca35de60c44645bbae8a215061b33";
        String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
        String channel  = "7d72365eb983485397e3e3f9d460bdda";
        int ts = 1446455472;
        int r = 58964981;
        long uid = 2882341273L;
        int expiredTs=1446455471;

        String expected = "004ec32c0d528e58ef90e8ff437a9706124137dc795970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
        String result = DynamicKey4.generatePublicSharingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
        assertEquals(expected, result);
    }

    @Test
    public void testGenerateRecordingKey() throws Exception {
        String appID   = "970ca35de60c44645bbae8a215061b33";
        String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
        String channel  = "7d72365eb983485397e3e3f9d460bdda";
        int ts = 1446455472;
        int r = 58964981;
        long uid = 2882341273L;
        int expiredTs=1446455471;

        String expected = "004e0c24ac56aae05229a6d9389860a1a0e25e56da8970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
        String result = DynamicKey4.generateRecordingKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
        assertEquals(expected, result);
    }

    @Test
    public void testGenerateMediaChannelKey() throws Exception {
        String appID   = "970ca35de60c44645bbae8a215061b33";
        String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
        String channel  = "7d72365eb983485397e3e3f9d460bdda";
        int ts = 1446455472;
        int r = 58964981;
        long uid = 2882341273L;
        int expiredTs=1446455471;

        String expected = "004d0ec5ee3179c964fe7c0485c045541de6bff332b970ca35de60c44645bbae8a215061b3314464554720383bbf51446455471";
        String result = DynamicKey4.generateMediaChannelKey(appID, appCertificate, channel, ts, r, uid, expiredTs);
        assertEquals(expected, result);
    }
}
