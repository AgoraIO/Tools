package io.agora.sample

import io.agora.media.ConvoAITokenBuilder
import io.agora.media.RtcTokenBuilder2

fun main() {
    val appId = System.getenv("AGORA_APP_ID") ?: ""
    val appCertificate = System.getenv("AGORA_APP_CERTIFICATE") ?: ""

    println("App Id: $appId")
    if (appId.isEmpty() || appCertificate.isEmpty()) {
        println("Need to set environment variable AGORA_APP_ID and AGORA_APP_CERTIFICATE")
        return
    }

    val token = ConvoAITokenBuilder.buildToken(
        appId,
        appCertificate,
        "7d72365eb983485397e3e3f9d460bdda",
        "2082341273",
        RtcTokenBuilder2.Role.ROLE_PUBLISHER,
        3600,
        3600,
        3600,
        3600,
        3600,
        "2082341273",
        3600
    )
    println("ConvoAI token: $token")
}
