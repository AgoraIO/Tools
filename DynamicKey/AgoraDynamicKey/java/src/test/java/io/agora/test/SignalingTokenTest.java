package io.agora.test;

import io.agora.signal.SignalingToken;

import java.security.NoSuchAlgorithmException;

import static org.junit.Assert.assertEquals;

public class SignalingTokenTest {

    public void testSignalingToken() throws NoSuchAlgorithmException {

        String appId = "970ca35de60c44645bbae8a215061b33";
        String certificate = "5cfd2fd1755d40ecb72977518be15d3b";
        String account = "TestAccount";
        int expiredTsInSeconds = 1446455471;
        String expected = "1:970ca35de60c44645bbae8a215061b33:1446455471:4815d52c4fd440bac35b981c12798774";
        String result = SignalingToken.getToken(appId, certificate, account, expiredTsInSeconds);
        assertEquals(expected,result);

    }
}
