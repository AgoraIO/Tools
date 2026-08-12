package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class SttTokenBuilderTest {
    @Test
    fun buildTokenPublisher() {
        val token = SttTokenBuilder.buildToken(
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
        )
        val parsed = AccessToken2()
        assertTrue(parsed.parse(token))
        assertEquals(1, parsed.getServices(AccessToken2.SERVICE_TYPE_STT).size)
    }
}
