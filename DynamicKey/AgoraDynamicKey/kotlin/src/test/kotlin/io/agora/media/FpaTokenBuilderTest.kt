package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests FPA Token007 builder workflows. */
class FpaTokenBuilderTest {
    /** Builds an FPA token with a 24-hour lifetime and login privilege. */
    @Test
    fun buildsToken() {
        val parser = AccessToken2()
        assertTrue(parser.parse(FpaTokenBuilder().buildToken(APP_ID, APP_CERTIFICATE)))
        assertTrue(parser.verifySignature(APP_CERTIFICATE))
        assertEquals(APP_ID, parser.appId)
        assertEquals(24 * 3600, parser.expire)
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_FPA)[0]
        assertEquals(0, service.privileges[AccessToken2.PrivilegeFpa.PRIVILEGE_LOGIN.intValue])
    }

    private companion object {
        const val APP_ID = "970CA35de60c44645bbae8a215061b33"
        const val APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
    }
}
