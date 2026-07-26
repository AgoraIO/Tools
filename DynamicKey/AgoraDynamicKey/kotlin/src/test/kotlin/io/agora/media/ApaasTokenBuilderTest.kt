package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests APaaS Token007 builder workflows. */
class ApaasTokenBuilderTest {
    private val builder = ApaasTokenBuilder()

    /** Builds a room-user token containing APaaS, RTM, and Chat services. */
    @Test
    fun buildsRoomUserToken() {
        val parser = parseAndVerify(
            builder.buildRoomUserToken(APP_ID, APP_CERTIFICATE, ROOM_UUID, USER_UUID, ROLE, EXPIRE)
        )

        val apaas = parser.getServices(AccessToken2.SERVICE_TYPE_APAAS)[0] as AccessToken2.ServiceApaas
        assertEquals(ROOM_UUID, apaas.roomUuid)
        assertEquals(USER_UUID, apaas.userUuid)
        assertEquals(ROLE, apaas.role)
        assertEquals(EXPIRE, apaas.privileges[AccessToken2.PrivilegeApaas.PRIVILEGE_ROOM_USER.intValue])

        val rtm = parser.getServices(AccessToken2.SERVICE_TYPE_RTM)[0] as AccessToken2.ServiceRtm
        assertEquals(USER_UUID, rtm.userId)
        assertEquals(EXPIRE, rtm.privileges[AccessToken2.PrivilegeRtm.PRIVILEGE_LOGIN.intValue])

        val chat = parser.getServices(AccessToken2.SERVICE_TYPE_CHAT)[0] as AccessToken2.ServiceChat
        assertEquals(CHAT_USER_ID, chat.userId)
        assertEquals(EXPIRE, chat.privileges[AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue])
    }

    /** Builds an APaaS user token with the expected default room and role. */
    @Test
    fun buildsUserToken() {
        val parser = parseAndVerify(builder.buildUserToken(APP_ID, APP_CERTIFICATE, USER_UUID, EXPIRE))
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_APAAS)[0] as AccessToken2.ServiceApaas

        assertEquals("", service.roomUuid)
        assertEquals(USER_UUID, service.userUuid)
        assertEquals((-1).toShort(), service.role)
        assertEquals(EXPIRE, service.privileges[AccessToken2.PrivilegeApaas.PRIVILEGE_USER.intValue])
    }

    /** Builds an APaaS application token with empty user fields. */
    @Test
    fun buildsAppToken() {
        val parser = parseAndVerify(builder.buildAppToken(APP_ID, APP_CERTIFICATE, EXPIRE))
        val service = parser.getServices(AccessToken2.SERVICE_TYPE_APAAS)[0] as AccessToken2.ServiceApaas

        assertEquals("", service.roomUuid)
        assertEquals("", service.userUuid)
        assertEquals((-1).toShort(), service.role)
        assertEquals(EXPIRE, service.privileges[AccessToken2.PrivilegeApaas.PRIVILEGE_APP.intValue])
    }

    /** Parses a generated token and verifies its signature. */
    private fun parseAndVerify(token: String): AccessToken2 = AccessToken2().also {
        assertTrue(it.parse(token))
        assertTrue(it.verifySignature(APP_CERTIFICATE))
        assertEquals(APP_ID, it.appId)
        assertEquals(EXPIRE, it.expire)
    }

    private companion object {
        const val APP_ID = "970CA35de60c44645bbae8a215061b33"
        const val APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
        const val ROOM_UUID = "123"
        const val USER_UUID = "2882341273"
        const val CHAT_USER_ID = "6063383428a36fba3fb6030becf8094e"
        const val ROLE: Short = 1
        const val EXPIRE = 600
    }
}
