package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests RTC and combined RTC/RTM token builders. */
class RtcTokenBuilder2Test {
    private val builder = RtcTokenBuilder2()

    /** Builds RTC tokens for numeric and string identities with role-based privileges. */
    @Test
    fun buildsRoleBasedRtcTokens() {
        val publisher = builder.buildTokenWithUid(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            UID,
            RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            TOKEN_EXPIRE,
            PRIVILEGE_EXPIRE
        )
        assertRtcService(publisher, UID.toString(), 4)

        val subscriber = builder.buildTokenWithUserAccount(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            USER_ACCOUNT,
            RtcTokenBuilder2.Role.ROLE_SUBSCRIBER,
            TOKEN_EXPIRE,
            PRIVILEGE_EXPIRE
        )
        assertRtcService(subscriber, USER_ACCOUNT, 1)
    }

    /** Builds RTC tokens with independent privilege expiration values. */
    @Test
    fun buildsRtcTokensWithIndependentPrivileges() {
        val uidToken = builder.buildTokenWithUid(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            0,
            TOKEN_EXPIRE,
            101,
            102,
            103,
            104
        )
        assertRtcService(uidToken, "", 4)

        val accountToken = builder.buildTokenWithUserAccount(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            USER_ACCOUNT,
            TOKEN_EXPIRE,
            101,
            102,
            103,
            104
        )
        val service = assertRtcService(accountToken, USER_ACCOUNT, 4)
        assertEquals(101, service.privileges[AccessToken2.PrivilegeRtc.PRIVILEGE_JOIN_CHANNEL.intValue])
        assertEquals(104, service.privileges[AccessToken2.PrivilegeRtc.PRIVILEGE_PUBLISH_DATA_STREAM.intValue])
    }

    /** Builds combined RTC and RTM tokens with shared and independent identities. */
    @Test
    fun buildsCombinedRtcAndRtmTokens() {
        val sharedIdentityToken = builder.buildTokenWithRtm(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            USER_ACCOUNT,
            RtcTokenBuilder2.Role.ROLE_PUBLISHER,
            TOKEN_EXPIRE,
            PRIVILEGE_EXPIRE
        )
        assertCombinedServices(sharedIdentityToken, USER_ACCOUNT, USER_ACCOUNT)

        val independentIdentityToken = builder.buildTokenWithRtm2(
            APP_ID,
            APP_CERTIFICATE,
            CHANNEL_NAME,
            USER_ACCOUNT,
            RtcTokenBuilder2.Role.ROLE_SUBSCRIBER,
            TOKEN_EXPIRE,
            101,
            102,
            103,
            104,
            RTM_USER_ID,
            PRIVILEGE_EXPIRE
        )
        assertCombinedServices(independentIdentityToken, USER_ACCOUNT, RTM_USER_ID)
    }

    /** Parses and verifies one RTC service from a generated token. */
    private fun assertRtcService(token: String, expectedUid: String, privilegeCount: Int): AccessToken2.ServiceRtc {
        val parser = parseAndVerify(token)
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_RTC)[0] as AccessToken2.ServiceRtc
        assertEquals(CHANNEL_NAME, service.channelName)
        assertEquals(expectedUid, service.uid)
        assertEquals(privilegeCount, service.privileges.size)
        return service
    }

    /** Parses and verifies the RTC and RTM services in a combined token. */
    private fun assertCombinedServices(token: String, rtcAccount: String, rtmUserId: String) {
        val parser = parseAndVerify(token)
        assertEquals(rtcAccount, (parser.getServices(AccessToken2.SERVICE_TYPE_RTC)[0] as AccessToken2.ServiceRtc).uid)
        assertEquals(rtmUserId, (parser.getServices(AccessToken2.SERVICE_TYPE_RTM)[0] as AccessToken2.ServiceRtm).userId)
    }

    /** Parses a generated token and verifies its signature. */
    private fun parseAndVerify(token: String): AccessToken2 = AccessToken2().also {
        assertTrue(it.parse(token))
        assertTrue(it.verifySignature(APP_CERTIFICATE))
    }

    private companion object {
        const val APP_ID = "970CA35de60c44645bbae8a215061b33"
        const val APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
        const val CHANNEL_NAME = "7d72365eb983485397e3e3f9d460bdda"
        const val USER_ACCOUNT = "test_user"
        const val RTM_USER_ID = "rtm_user"
        const val UID = 288234127
        const val TOKEN_EXPIRE = 600
        const val PRIVILEGE_EXPIRE = 500
    }
}
