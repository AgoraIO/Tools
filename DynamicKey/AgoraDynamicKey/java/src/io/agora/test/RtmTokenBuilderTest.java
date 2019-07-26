package io.agora.test;

import org.junit.Test;
import io.agora.rtm.RtmTokenBuilder;
import io.agora.rtm.RtmTokenBuilder.Role;
import io.agora.media.AccessToken;
import io.agora.media.Utils;

import static org.junit.Assert.*;

public class RtmTokenBuilderTest {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expireTimestamp = 1446455471;

    @Test
    public void testRtmTokenBuilderWithDefalutPriviledge() throws Exception {
    	RtmTokenBuilder builder = new RtmTokenBuilder();
    	String result = builder.buildToken(appId, appCertificate, userId, Role.Rtm_User, expireTimestamp);
    	
    	RtmTokenBuilder tester = new RtmTokenBuilder();
    	tester.mTokenCreator = new AccessToken("", "", "", "");
    	tester.mTokenCreator.fromString(result);
    	
    	assertEquals(builder.mTokenCreator.appId, tester.mTokenCreator.appId);
    	assertEquals(builder.mTokenCreator.crcChannelName, tester.mTokenCreator.crcChannelName);
    	assertEquals(builder.mTokenCreator.message.salt, tester.mTokenCreator.message.salt);
    }
}
