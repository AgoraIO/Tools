package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class SttTokenBuilderTest {
    @Test
    public void buildTokenPublisher() {
        String token = SttTokenBuilder.buildToken(
                "970CA35de60c44645bbae8a215061b33",
                "5CFd2fd1755d40ecb72977518be15d3b",
                "stt-channel",
                "stt-rtc-user",
                RtcTokenBuilder2.Role.ROLE_PUBLISHER,
                3600,
                1800,
                1700,
                1600,
                1500,
                "stt-rtm-user",
                1400
        );
        AccessToken2 parsed = new AccessToken2();
        assertTrue(parsed.parse(token));
        assertEquals(1, parsed.getServices(AccessToken2.SERVICE_TYPE_STT).size());
    }
}
