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
        "convoai-channel",
        "convoai-rtc-user",
        RtcTokenBuilder2.Role.ROLE_PUBLISHER,
        3600,
        3600,
        3600,
        3600,
        3600,
        "convoai-rtm-user",
        3600
    )
    println("ConvoAI token: $token")
}
