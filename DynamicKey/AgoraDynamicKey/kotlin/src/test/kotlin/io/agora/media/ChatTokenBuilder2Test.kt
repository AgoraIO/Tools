package io.agora.media

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

/** Tests Chat user and application token builders. */
class ChatTokenBuilder2Test {
    /** Builds and verifies Chat user and application tokens. */
    @Test
    fun buildsUserAndApplicationTokens() {
        val builder = ChatTokenBuilder2()
        val userService = parseChatService(builder.buildUserToken(APP_ID, APP_CERTIFICATE, USER_ID, EXPIRE))
        assertEquals(USER_ID, userService.userId)
        assertEquals(EXPIRE, userService.privileges[AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_USER.intValue])

        val appService = parseChatService(builder.buildAppToken(APP_ID, APP_CERTIFICATE, EXPIRE))
        assertEquals("", appService.userId)
        assertEquals(EXPIRE, appService.privileges[AccessToken2.PrivilegeChat.PRIVILEGE_CHAT_APP.intValue])
    }

    /** Parses and verifies a generated Chat token. */
    private fun parseChatService(token: String): AccessToken2.ServiceChat {
        val parser = AccessToken2()
        assertTrue(parser.parse(token))
        assertTrue(parser.verifySignature(APP_CERTIFICATE))
        return parser.getServices(AccessToken2.SERVICE_TYPE_CHAT)[0] as AccessToken2.ServiceChat
    }

    private companion object {
        const val APP_ID = "970CA35de60c44645bbae8a215061b33"
        const val APP_CERTIFICATE = "5CFd2fd1755d40ecb72977518be15d3b"
        const val USER_ID = "test_user"
        const val EXPIRE = 600
    }
}
