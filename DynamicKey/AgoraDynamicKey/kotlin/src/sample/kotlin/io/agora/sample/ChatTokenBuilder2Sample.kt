package io.agora.sample

import io.agora.media.ChatTokenBuilder2

/** Demonstrates Chat Token007 generation. */
object ChatTokenBuilder2Sample {
    /** Generates and prints Chat user and application sample tokens. */
    @JvmStatic
    fun main(args: Array<String>) {
        val appId = System.getenv("AGORA_APP_ID")
        val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        val builder = ChatTokenBuilder2()
        println("Chat user token: ${builder.buildUserToken(appId, appCertificate, USER_ID, EXPIRE)}")
        println("Chat app token: ${builder.buildAppToken(appId, appCertificate, EXPIRE)}")
    }

    private const val USER_ID = "2882341273"
    private const val EXPIRE = 600
}
