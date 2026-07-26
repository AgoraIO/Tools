package io.agora.sample

import io.agora.media.FpaTokenBuilder

/** Demonstrates FPA Token007 generation. */
object FpaTokenBuilderSample {
    /** Generates and prints an FPA sample token. */
    @JvmStatic
    fun main(args: Array<String>) {
        val appId = System.getenv("AGORA_APP_ID")
        val appCertificate = System.getenv("AGORA_APP_CERTIFICATE")
        if (appId.isNullOrEmpty() || appCertificate.isNullOrEmpty()) {
            println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
            return
        }

        println("FPA token: ${FpaTokenBuilder().buildToken(appId, appCertificate)}")
    }
}
