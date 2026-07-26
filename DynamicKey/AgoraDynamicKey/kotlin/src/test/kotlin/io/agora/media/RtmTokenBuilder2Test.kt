package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests RTM and RTM2 builder behavior. */
class RtmTokenBuilder2Test {
    /** Builds a legacy RTM token and verifies the parsed service. */
    @Test
    fun buildToken() {
        val token = RtmTokenBuilder2().buildToken(APP_ID, APP_CERTIFICATE, USER_ID, EXPIRE)
        val parser = AccessToken2()

        assertTrue(parser.parse(token))
        assertTrue(parser.verifySignature(APP_CERTIFICATE))
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_RTM)[0] as AccessToken2.ServiceRtm
        assertEquals(USER_ID, service.userId)
        assertEquals(EXPIRE, service.privileges[AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue])
    }

    /** Builds an RTM2 token with resource permissions and verifies the parsed service. */
    @Test
    fun buildTokenWithPermissions() {
        val permissions = AccessToken2.ServiceRtm2.Permissions()
        permissions.add(
            AccessToken2.ServiceRtm2.Permissions.MESSAGE_CHANNELS,
            AccessToken2.ServiceRtm2.Permissions.READ,
            listOf("message-a", "message-b")
        )
        permissions.add(
            AccessToken2.ServiceRtm2.Permissions.STREAM_CHANNELS,
            AccessToken2.ServiceRtm2.Permissions.WRITE,
            listOf("stream-a")
        )

        val token = RtmTokenBuilder2().buildTokenWithPermissions(
            APP_ID,
            APP_CERTIFICATE,
            USER_ID,
            permissions,
            EXPIRE
        )
        val parser = AccessToken2()
        assertTrue(parser.parse(token))
        assertTrue(parser.verifySignature(APP_CERTIFICATE))
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_RTM2)[0] as AccessToken2.ServiceRtm2
        assertEquals(USER_ID, service.userId)
        assertEquals(permissions.details, service.permissions.details)
    }

    private companion object {
        const val APP_ID = "970CA35de60c44645bbae8a215061b33"
        const val APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
        const val USER_ID = "test_user"
        const val EXPIRE = 600
    }
}
