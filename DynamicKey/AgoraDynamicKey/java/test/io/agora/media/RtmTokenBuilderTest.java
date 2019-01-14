package io.agora.media;

import org.junit.Test;
import io.agora.media.RtmTokenBuilder;
import io.agora.media.Utils;

import static org.junit.Assert.*;

public class RtmTokenBuilderTest {
    private String appId = "970CA35de60c44645bbae8a215061b33";
    private String appCertificate = "5CFd2fd1755d40ecb72977518be15d3b";
    private String userId = "test_user";
    private int expireTimestamp = 1446455471;

    @Test
    public void testRtmTokenBuilderWithDefalutPriviledge() throws Exception {
        String expected =
            "006970CA35de60c44645bbae8a215061b33IAAsR0qgiCxv0vrpRcpkz5BrbfEWCBZ6kvR6t7qG/wJIQob86ogAAAAAEAABAAAAR/QQAAEA6AOvKDdW";
        RtmTokenBuilder builder = new RtmTokenBuilder(appId, appCertificate, userId);
        builder.mTokenCreator.message.salt = 1;
        builder.mTokenCreator.message.ts = 1111111;
        builder.setPrivilege(AccessToken.Privileges.kRtmLogin, expireTimestamp);
        testRtmTokenBuilder(expected, builder);
    }

    @Test
    public void testRtmTokenBuilderWithLimitPriviledge() throws Exception {
        String expected =
            "006970CA35de60c44645bbae8a215061b33IABR8ywaENKv6kia6iUU6P54g017Bi6Ym9sIGdt9f3sLLYb86ogAAAAAEAABAAAAR/QQAAEA6ANkAAAA";
        RtmTokenBuilder builder = new RtmTokenBuilder(appId, appCertificate, userId);
        builder.mTokenCreator.message.salt = 1;
        builder.mTokenCreator.message.ts = 1111111;
        builder.setPrivilege(AccessToken.Privileges.kRtmLogin, 100);
        testRtmTokenBuilder(expected, builder);
    }

    private void testRtmTokenBuilder(String expected, RtmTokenBuilder orgBuilder) throws Exception {
        String result = orgBuilder.buildToken();
        assertEquals(expected, result);

        if (expected == "") {
          return;
        }
        RtmTokenBuilder builder = new RtmTokenBuilder("", "", "");
        boolean parsed = builder.initTokenBuilder(result);
        assertTrue(parsed);
        assertEquals(builder.mTokenCreator.appId, orgBuilder.mTokenCreator.appId);
        assertEquals(builder.mTokenCreator.crcChannelName, orgBuilder.mTokenCreator.crcChannelName);
        assertEquals(builder.mTokenCreator.crcUid, orgBuilder.mTokenCreator.crcUid);
        int crcChannelName = Utils.crc32(orgBuilder.mTokenCreator.channelName);
        int crcUid = Utils.crc32(orgBuilder.mTokenCreator.uid);
        assertEquals(builder.mTokenCreator.crcChannelName, crcChannelName);
        assertEquals(builder.mTokenCreator.crcUid, crcUid);
        assertEquals(builder.mTokenCreator.message.ts, orgBuilder.mTokenCreator.message.ts);
        assertEquals(builder.mTokenCreator.message.salt, orgBuilder.mTokenCreator.message.salt);
        assertEquals(builder.mTokenCreator.message.messages.get(AccessToken.Privileges.kRtmLogin.intValue),
                orgBuilder.mTokenCreator.message.messages.get(AccessToken.Privileges.kRtmLogin.intValue));

        byte[] signature = AccessToken.generateSignature(
                appCertificate, orgBuilder.mTokenCreator.appId, orgBuilder.mTokenCreator.channelName, orgBuilder.mTokenCreator.uid,
                orgBuilder.mTokenCreator.messageRawContent);
        assertArrayEquals(builder.mTokenCreator.signature, signature);
      }
}
