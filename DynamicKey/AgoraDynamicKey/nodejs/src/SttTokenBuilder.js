const AccessToken = require('../src/AccessToken2').AccessToken2
const ServiceRtc = require('../src/AccessToken2').ServiceRtc
const ServiceRtm = require('../src/AccessToken2').ServiceRtm
const ServiceStt = require('../src/AccessToken2').ServiceStt
const Role = require('../src/RtcTokenBuilder2').Role

class SttTokenBuilder {
    /**
     * Builds a Token007 that carries RTC, RTM, and STT services.
     * @param {*} appId The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format.
     * @param {*} rtcAccount The RTC user's account, max length is 255 bytes.
     * @param {*} rtcRole Role.PUBLISHER for a broadcaster or Role.SUBSCRIBER for an audience member.
     * @param {*} rtcTokenExpire Represented by the number of seconds elapsed since now. This is the whole
     * token expiration. The whole token is invalid after this time, even if a privilege expiration time is
     * later.
     * @param {*} joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now. This
     * value must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now. This value
     * must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now. This
     * value must not exceed rtcTokenExpire; otherwise, the privilege is limited by the token expiration time.
     * @param {*} rtmUserId The RTM user's account, max length is 255 bytes.
     * @param {*} rtmTokenExpire Represented by the number of seconds elapsed since now. This value must not
     * exceed rtcTokenExpire; otherwise, the RTM login privilege is limited by the token expiration time.
     * @return The RTC, RTM, and STT token.
     */
    static buildToken(
        appId,
        appCertificate,
        channelName,
        rtcAccount,
        rtcRole,
        rtcTokenExpire,
        joinChannelPrivilegeExpire,
        pubAudioPrivilegeExpire,
        pubVideoPrivilegeExpire,
        pubDataStreamPrivilegeExpire,
        rtmUserId,
        rtmTokenExpire
    ) {
        const token = new AccessToken(appId, appCertificate, 0, rtcTokenExpire)

        const serviceRtc = new ServiceRtc(channelName, rtcAccount)
        serviceRtc.add_privilege(ServiceRtc.kPrivilegeJoinChannel, joinChannelPrivilegeExpire)
        if (rtcRole === Role.PUBLISHER) {
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishAudioStream, pubAudioPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishVideoStream, pubVideoPrivilegeExpire)
            serviceRtc.add_privilege(ServiceRtc.kPrivilegePublishDataStream, pubDataStreamPrivilegeExpire)
        }
        token.add_service(serviceRtc)

        const serviceRtm = new ServiceRtm(rtmUserId)
        serviceRtm.add_privilege(ServiceRtm.kPrivilegeLogin, rtmTokenExpire)
        token.add_service(serviceRtm)

        token.add_service(new ServiceStt())

        return token.build()
    }
}

module.exports = {
    SttTokenBuilder
}
