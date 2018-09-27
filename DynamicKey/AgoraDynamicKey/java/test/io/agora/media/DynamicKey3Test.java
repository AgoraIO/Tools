package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by liwei on 5/4/16.
 */
public class DynamicKey3Test {

    @Test
    public void testGenerate() throws Exception {
        String appID   = "970ca35de60c44645bbae8a215061b33";
        String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
        String channel  = "7d72365eb983485397e3e3f9d460bdda";
        int ts = 1446455472;
        int r = 58964981;
        long uid = 2882341273L;
        int expiredTs = 1446455471;

        String result = DynamicKey3.generate(appID, appCertificate, channel, ts, r, uid, expiredTs);

        String expected = "0037666966591a93ee5a3f712e22633f31f0cbc8f13970ca35de60c44645bbae8a215061b3314464554720383bbf528823412731446455471";
        assertEquals(expected, result);
    }
}
