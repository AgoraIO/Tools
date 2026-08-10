import { AccessToken2 as AccessToken, ServiceRtc, ServiceRtm, ServiceStt } from '../src/AccessToken2.js'
import { Role } from '../src/RtcTokenBuilder2.js'

class SttTokenBuilder {
    /**
     * Builds a Token007 that carries RTC, RTM, and STT services.
     * @param {*} appId The App ID issued to you by Agora.
     * @param {*} appCertificate Certificate of the application that you registered in the Agora Dashboard.
     * @param {*} channelName The unique channel name for the AgoraRTC session in the string format.
     * @param {*} rtcAccount The RTC user's account, max length is 255 bytes.
     * @param {*} rtcRole Role.PUBLISHER for a broadcaster or Role.SUBSCRIBER for an audience member.
     * @param {*} rtcTokenExpire Represented by the number of seconds elapsed since now.
     * @param {*} joinChannelPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param {*} pubAudioPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param {*} pubVideoPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param {*} pubDataStreamPrivilegeExpire Represented by the number of seconds elapsed since now.
     * @param {*} rtmUserId The RTM user's account, max length is 255 bytes.
     * @param {*} rtmTokenExpire Represented by the number of seconds elapsed since now.
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
        rtmTokenExpire,
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

export { SttTokenBuilder }
