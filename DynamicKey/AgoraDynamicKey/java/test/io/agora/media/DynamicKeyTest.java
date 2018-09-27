package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.*;

/**
 * Created by liwei on 5/4/16.
 */
public class DynamicKeyTest {

    @Test
    public void testGenerate() throws Exception {
        String appID   = "970ca35de60c44645bbae8a215061b33";
        String appCertificate      = "5cfd2fd1755d40ecb72977518be15d3b";
        String channel  = "7d72365eb983485397e3e3f9d460bdda";
        int ts = 1446455472;
        int r = 58964981;
        int uid = 999;
        int expiredTs = 1446455471;
        String result = DynamicKey.generate(appID, appCertificate, channel, ts, r);

        String expected = "870588aad271ff47094eb622617e89d6b5b5a615970ca35de60c44645bbae8a215061b3314464554720383bbf5";
        assertEquals(expected, result);
    }
}
