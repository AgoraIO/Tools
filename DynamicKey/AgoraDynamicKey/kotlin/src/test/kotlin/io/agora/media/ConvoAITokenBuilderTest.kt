package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ConvoAITokenBuilderTest {
    @Test
    fun buildTokenPublisher() {
        val token = ConvoAITokenBuilder.buildToken(
            "970CA35de60c44645bbae8a215061b33",
            "5CFd2fd1755d40ecb72977518be15d3b",
            "convoai-channel",
            "convoai-rtc-user",
            RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            3600,
            1800,
            1700,
            1600,
            1500,
            "convoai-rtm-user",
            1400
        )
        val parsed = AccessToken2()
        assertTrue(parsed.parse(token))
        assertEquals(1, parsed.getServices(AccessToken2.SERVICE_TYPE_CONVOAI).size)
    }
}
