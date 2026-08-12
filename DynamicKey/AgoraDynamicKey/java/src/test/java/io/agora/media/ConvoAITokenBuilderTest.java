package io.agora.media;

import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class ConvoAITokenBuilderTest {
    @Test
    public void buildTokenPublisher() {
        String token = ConvoAITokenBuilder.buildToken(
                "970CA35de60c44645bbae8a215061b33",
                "5CFd2fd1755d40ecb72977518be15d3b",
                "7d72365eb983485397e3e3f9d460bdda",
                "2082341273",
                RtcTokenBuilder2.Role.ROLE_PUBLISHER,
                600,
                600,
                600,
                600,
                600,
                "2082341273",
                600
        );
        AccessToken2 parsed = new AccessToken2();
        assertTrue(parsed.parse(token));
        assertEquals(1, parsed.getServices(AccessToken2.SERVICE_TYPE_CONVOAI).size());
    }
}
